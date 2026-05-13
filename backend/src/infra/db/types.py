"""Typed structures shared by the database layer."""

from dataclasses import dataclass
from typing import TYPE_CHECKING, NotRequired, TypedDict

if TYPE_CHECKING:
    from .models.service import SocialService


class LawChunkType(TypedDict):
    """Shape of a law chunk before it is converted into an ORM model.

    Attributes:
        document_number: Official document identifier of the source law.
        year: Publication year of the source document.
        source_kind: Chunk origin, either ``fragment`` or ``pdf``.
        fragment_id: Unique identifier of the source fragment when available.
        depth: Fragment depth in the source hierarchy when available.
        fragment_type: Fragment type label from the source dataset.
        page_start: First PDF page covered by the chunk.
        page_end: Last PDF page covered by the chunk.
        chunk_index: Chunk order within the source document.
        section_title: Optional section/article title detected during chunking.
        source_filename: Original uploaded filename.
        clean_text: Plain-text content extracted from the source HTML.
        embedding: Optional embedding vector generated for the fragment text.
    """

    document_number: str
    year: int
    source_kind: str
    clean_text: str | None
    embedding: list[float] | None
    fragment_id: NotRequired[int | None]
    depth: NotRequired[int | None]
    fragment_type: NotRequired[str | None]
    page_start: NotRequired[int | None]
    page_end: NotRequired[int | None]
    chunk_index: NotRequired[int | None]
    section_title: NotRequired[str | None]
    source_filename: NotRequired[str | None]


@dataclass(slots=True)
class ServiceLocationSummary:
    """Lightweight location payload used by the map list endpoint."""

    id: int
    service_id: int
    provider_id: int
    street: str | None
    number: str | None
    district: str | None
    municipality: str | None
    postal_code: str | None
    region: str | None
    service_name: str | None
    lat: float | None
    lon: float | None
    distance_km: float | None = None


@dataclass(slots=True)
class ServiceListRecord:
    """Single service row returned by the map list endpoint."""

    service: "SocialService"
    location: ServiceLocationSummary | None
    locations_count: int
    target_groups_count: int
    distance_km: float | None
    semantic_distance: float | None = None


@dataclass(slots=True)
class ServiceListResult:
    """Paginated map service result set."""

    items: list[ServiceListRecord]
    total: int
