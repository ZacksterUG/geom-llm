from pydantic import BaseModel, Field, ConfigDict
from typing import Optional, List
from uuid import UUID

# Базовая схема для элементов фигуры
class Vertex(BaseModel):
    id: str
    x: float
    y: float
    z: float

class Edge(BaseModel):
    from_: str = Field(alias="from")
    to: str
    relation: Optional[str] = None

class FigureState(BaseModel):
    vertices: List[Vertex] = []
    edges: List[Edge] = []
    relations: List[str] = []
    actions_log: List[str] = []

class ProofStep(BaseModel):
    step_id: int
    claim: str
    justification_id: Optional[str] = None
    comment: Optional[str] = None

class PolyhedronTypeResponse(BaseModel):
    id: int
    name: str
    display_order: int

class TaskResponse(BaseModel):
    id: UUID
    title: str
    condition_text: str
    initial_figure_state: FigureState
    reference_figure_state: Optional[FigureState] = None
    reference_proof: Optional[List[ProofStep]] = None
    difficulty_level: str
    polyhedron_types: List[PolyhedronTypeResponse] = []

class PaginatedTaskResponse(BaseModel):
    items: List[TaskResponse]
    total: int
    page: int
    page_size: int
    total_pages: int

class ValidationRequest(BaseModel):
    task_id: UUID
    task_condition: str
    figure_state: FigureState
    proof_history: List[ProofStep]
    current_step: ProofStep

class ValidationResponse(BaseModel):
    model_config = ConfigDict(extra='ignore')

    status: str
    geometry_valid: bool
    logic_valid: bool
    reason: str
    hint: str
    referenced_theorem: Optional[str] = None
    next_allowed_actions: List[str] = []
