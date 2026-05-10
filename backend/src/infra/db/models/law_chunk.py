"""SQLAlchemy model for law chunk records and their embeddings."""

from sqlalchemy import Integer, String, Text
from sqlalchemy.orm import Mapped, mapped_column
from pgvector.sqlalchemy import Vector  # type: ignore

from src.infra.db.mixins import IdIntegerMixin
from src.infra.db.models.base import Base


class LawChunk(IdIntegerMixin, Base):
    """Persist a normalized law fragment or PDF chunk and its embedding.

    Attributes:
        id: Auto-incrementing primary key inherited from ``IdIntegerMixin``.
        document_number: Official document identifier of the source law.
        year: Publication year of the source document.
        source_kind: ``fragment`` for JSON fragments or ``pdf`` for PDF chunks.
        fragment_id: Unique identifier of the source fragment when available.
        depth: Fragment depth in the source hierarchy when available.
        fragment_type: Fragment type label from the source dataset.
        page_start: First PDF page covered by the chunk.
        page_end: Last PDF page covered by the chunk.
        chunk_index: Chunk order within the source document.
        section_title: Optional section/article title detected during chunking.
        source_filename: Original uploaded filename.
        clean_text: Plain-text content extracted from the source document.
        embedding: Optional 768-dimensional vector used for semantic search.
    """

    # Document metadata
    document_number: Mapped[str] = mapped_column(
        String(100), index=True, nullable=False
    )  # example "268/2025 Sb."
    year: Mapped[int] = mapped_column(Integer, nullable=False)
    source_kind: Mapped[str] = mapped_column(
        String(20), index=True, nullable=False
    )  # fragment | pdf

    # Fragment metadata
    fragment_id: Mapped[int | None] = mapped_column(
        Integer, unique=True, index=True, nullable=True
    )  # 1075645819
    depth: Mapped[int | None] = mapped_column(Integer, nullable=True)  # hloubka
    fragment_type: Mapped[str | None] = mapped_column(
        String(50), nullable=True
    )  # typ: "Odstavec_Dc", "Bod_Dd"

    # PDF chunk metadata
    page_start: Mapped[int | None] = mapped_column(Integer, nullable=True)
    page_end: Mapped[int | None] = mapped_column(Integer, nullable=True)
    chunk_index: Mapped[int | None] = mapped_column(Integer, index=True, nullable=True)
    section_title: Mapped[str | None] = mapped_column(String(255), nullable=True)
    source_filename: Mapped[str | None] = mapped_column(String(255), nullable=True)

    # Content
    clean_text: Mapped[str | None] = mapped_column(Text, nullable=True)

    # Embedding
    embedding: Mapped[list[float] | None] = mapped_column(Vector(768), nullable=True)
