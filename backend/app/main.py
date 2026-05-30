from fastapi import FastAPI, HTTPException, Depends, Query
from fastapi.middleware.cors import CORSMiddleware
from typing import Optional
from app.models.schemas import (
    TaskResponse, PaginatedTaskResponse, PolyhedronTypeResponse,
    ValidationRequest, ValidationResponse
)
from app.models.tables import TaskTable, PolyhedronType, Base
from app.db.session import engine, get_db
from app.core.ollama_client import validate_with_ollama
from sqlalchemy.orm import Session, joinedload
from sqlalchemy import or_
import uuid
import math
import logging

logger = logging.getLogger(__name__)

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Stereometry Proof Checker API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.get("/api/tasks", response_model=PaginatedTaskResponse)
async def get_tasks(
    search: Optional[str] = Query(None, description="Text search in title and condition"),
    polyhedron_type_ids: Optional[str] = Query(None, description="Comma-separated polyhedron type IDs"),
    date_from: Optional[str] = Query(None, description="Filter by created_at >= date (ISO format)"),
    date_to: Optional[str] = Query(None, description="Filter by created_at <= date (ISO format)"),
    sort_by: str = Query("created_at", description="Sort field: created_at, title"),
    sort_order: str = Query("desc", description="Sort order: asc or desc"),
    page: int = Query(1, ge=1, description="Page number"),
    page_size: int = Query(10, ge=1, le=100, description="Items per page"),
    db: Session = Depends(get_db),
):
    query = db.query(TaskTable).options(joinedload(TaskTable.polyhedron_types))

    if search:
        search_pattern = f"%{search}%"
        query = query.filter(
            or_(
                TaskTable.title.ilike(search_pattern),
                TaskTable.condition_text.ilike(search_pattern),
            )
        )

    if polyhedron_type_ids:
        ids = [int(x.strip()) for x in polyhedron_type_ids.split(",") if x.strip().isdigit()]
        if ids:
            query = query.join(TaskTable.polyhedron_types).filter(
                PolyhedronType.id.in_(ids)
            )

    if date_from:
        query = query.filter(TaskTable.created_at >= date_from)

    if date_to:
        query = query.filter(TaskTable.created_at <= date_to)

    sort_column = {
        "created_at": TaskTable.created_at,
        "title": TaskTable.title,
    }.get(sort_by, TaskTable.created_at)

    if sort_order == "asc":
        query = query.order_by(sort_column.asc())
    else:
        query = query.order_by(sort_column.desc())

    total = query.count()
    total_pages = math.ceil(total / page_size) if total > 0 else 1

    tasks = query.offset((page - 1) * page_size).limit(page_size).all()

    items = [
        TaskResponse(
            id=task.id,
            title=task.title,
            condition_text=task.condition_text,
            initial_figure_state=task.initial_figure_state,
            reference_figure_state=task.reference_figure_state,
            reference_proof=task.reference_proof,
            polyhedron_types=[
                PolyhedronTypeResponse(id=pt.id, name=pt.name, display_order=pt.display_order)
                for pt in task.polyhedron_types
            ],
        )
        for task in tasks
    ]

    return PaginatedTaskResponse(
        items=items,
        total=total,
        page=page,
        page_size=page_size,
        total_pages=total_pages,
    )


@app.get("/api/tasks/{task_id}", response_model=TaskResponse)
async def get_task(task_id: str, db: Session = Depends(get_db)):
    task = (
        db.query(TaskTable)
        .options(joinedload(TaskTable.polyhedron_types))
        .filter(TaskTable.id == uuid.UUID(task_id))
        .first()
    )
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return TaskResponse(
        id=task.id,
        title=task.title,
        condition_text=task.condition_text,
        initial_figure_state=task.initial_figure_state,
        reference_figure_state=task.reference_figure_state,
        reference_proof=task.reference_proof,
        polyhedron_types=[
            PolyhedronTypeResponse(id=pt.id, name=pt.name, display_order=pt.display_order)
            for pt in task.polyhedron_types
        ],
    )


@app.get("/api/polyhedron-types", response_model=list[PolyhedronTypeResponse])
async def get_polyhedron_types(db: Session = Depends(get_db)):
    types = db.query(PolyhedronType).order_by(PolyhedronType.display_order).all()
    return [
        PolyhedronTypeResponse(id=t.id, name=t.name, display_order=t.display_order)
        for t in types
    ]


@app.post("/api/validate", response_model=ValidationResponse)
async def validate_proof(request: ValidationRequest, db: Session = Depends(get_db)):
    try:
        result = await validate_with_ollama(
            request.task_condition,
            [step.model_dump() for step in request.proof_history],
            request.current_step.model_dump(),
            request.figure_state.model_dump(),
        )
        return ValidationResponse.model_validate(result)
    except Exception as e:
        logger.error(f"Validation endpoint error: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail=f"Internal validation error: {str(e)}")
