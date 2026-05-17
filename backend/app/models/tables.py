from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy import String, Text, DateTime, func, UUID
from sqlalchemy.dialects.postgresql import JSONB
from typing import Optional
import uuid

class Base(DeclarativeBase):
    pass

class TaskTable(Base):
    __tablename__ = "tasks"

    id: Mapped[uuid.UUID] = mapped_column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title: Mapped[str] = mapped_column(String(255), nullable=False)
    condition_text: Mapped[str] = mapped_column(Text, nullable=False)
    # Начальное состояние фигуры (до решения)
    initial_figure_state: Mapped[dict] = mapped_column(JSONB, nullable=False)
    # Эталонное построение (как должно выглядеть после решения)
    reference_figure_state: Mapped[Optional[dict]] = mapped_column(JSONB, nullable=True)
    # Эталонное доказательство (пошаговое)
    reference_proof: Mapped[Optional[list]] = mapped_column(JSONB, nullable=True)
    difficulty_level: Mapped[str] = mapped_column(String(50), default="10-11 класс")
    created_at: Mapped[DateTime] = mapped_column(DateTime(timezone=True), server_default=func.now())
