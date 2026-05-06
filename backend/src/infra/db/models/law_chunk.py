"""SQLAlchemy models for benefits and services database."""

from sqlalchemy import Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from pgvector.sqlalchemy import Vector  # type: ignore

from src.infra.db.mixins import IdIntegerMixin
from src.infra.db.models.base import Base


class LawChunk(IdIntegerMixin, Base):
    # Document metadata
    document_number: Mapped[str] = mapped_column(
        String(100), index=True, nullable=False
    )  # example "268/2025 Sb."
    year: Mapped[int] = mapped_column(Integer, nullable=False)

    # Fragment data
    fragment_id: Mapped[int] = mapped_column(
        Integer, unique=True, index=True, nullable=False
    )  # 1075645819
    depth: Mapped[int] = mapped_column(Integer, nullable=False)  # hloubka
    fragment_type: Mapped[str] = mapped_column(
        String(50), nullable=False
    )  # typ: "Odstavec_Dc", "Bod_Dd"

    # Content
    clean_text: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Embedding
    embedding: Mapped[list[float] | None] = mapped_column(Vector(1536), nullable=True)
