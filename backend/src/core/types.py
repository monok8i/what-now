"""Core types used across the project."""

from dataclasses import dataclass, field
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from src.infra.db.types import ServiceListRecord


@dataclass(slots=True)
class SearchChunkResult:
    """Single search hit returned by the search service."""

    document_number: str
    year: int
    source_kind: str
    fragment_id: int | None
    depth: int | None
    fragment_type: str | None
    page_start: int | None
    page_end: int | None
    chunk_index: int | None
    section_title: str | None
    source_filename: str | None
    clean_text: str | None
    distance: float


@dataclass(slots=True)
class SearchResultSet:
    """Search result payload with counts and ordered hits."""

    query: str
    total_chunks: int
    searchable_chunks: int
    results: list[SearchChunkResult]


@dataclass(slots=True)
class FirstAnswerResult:
    """Structured result of the first answer generation."""

    total_chunks: int
    message: str
    map_services: list["ServiceListRecord"] = field(default_factory=list)


@dataclass(slots=True)
class ChatReplyResult:
    """Structured result of a chat turn."""

    total_chunks: int
    message: str
