from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from app.models.schemas import TaskResponse, ValidationRequest, ValidationResponse
from app.models.tables import TaskTable, Base
from app.db.session import engine, get_db
from app.core.ollama_client import validate_with_ollama
from sqlalchemy.orm import Session
import uuid
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

@app.get("/api/tasks", response_model=list[TaskResponse])
async def get_tasks(db: Session = Depends(get_db)):
    tasks = db.query(TaskTable).all()
    return [
        TaskResponse(
            id=task.id,
            title=task.title,
            condition_text=task.condition_text,
            initial_figure_state=task.initial_figure_state,
            reference_figure_state=task.reference_figure_state,
            reference_proof=task.reference_proof,
            difficulty_level=task.difficulty_level,
        )
        for task in tasks
    ]

@app.get("/api/tasks/{task_id}", response_model=TaskResponse)
async def get_task(task_id: str, db: Session = Depends(get_db)):
    task = db.query(TaskTable).filter(TaskTable.id == uuid.UUID(task_id)).first()
    if not task:
        return {"error": "Task not found"}
    return TaskResponse(
        id=task.id,
        title=task.title,
        condition_text=task.condition_text,
        initial_figure_state=task.initial_figure_state,
        reference_figure_state=task.reference_figure_state,
        reference_proof=task.reference_proof,
        difficulty_level=task.difficulty_level,
    )

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

