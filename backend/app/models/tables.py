from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy import String, Text, DateTime, func, UUID, Integer, ForeignKey
from sqlalchemy.dialects.postgresql import JSONB
from typing import Optional
import uuid

class Base(DeclarativeBase):
    pass

class TaskPolyhedronType(Base):
    __tablename__ = "task_polyhedron_types"

    task_id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), ForeignKey("tasks.id", ondelete="CASCADE"), primary_key=True)
    polyhedron_type_id: Mapped[int] = mapped_column(Integer, ForeignKey("polyhedron_types.id", ondelete="CASCADE"), primary_key=True)


class PolyhedronType(Base):
    __tablename__ = "polyhedron_types"

    id: Mapped[int] = mapped_column(Integer, primary_key=True, autoincrement=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False, unique=True)
    display_order: Mapped[int] = mapped_column(Integer, default=0)


class TaskTable(Base):
    __tablename__ = "tasks"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    condition_text: Mapped[str] = mapped_column(Text, nullable=False)
    initial_figure_state: Mapped[dict] = mapped_column(JSONB, nullable=False)
    reference_figure_state: Mapped[Optional[dict]] = mapped_column(JSONB, nullable=True)
    reference_proof: Mapped[Optional[list]] = mapped_column(JSONB, nullable=True)
    difficulty_level: Mapped[str] = mapped_column(String(50), default="10-11 класс")
    created_at: Mapped[DateTime] = mapped_column(DateTime(timezone=True), server_default=func.now())

    polyhedron_types: Mapped[list[PolyhedronType]] = relationship(
        "PolyhedronType",
        secondary="task_polyhedron_types",
        primaryjoin="TaskTable.id == TaskPolyhedronType.task_id",
        secondaryjoin="PolyhedronType.id == TaskPolyhedronType.polyhedron_type_id",
        lazy="joined"
    )
