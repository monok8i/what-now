"""Pydantic models used by the API request and response payloads."""

from datetime import date
from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, model_validator


class LawUploadResponse(BaseModel):
    """Response returned after a law document is uploaded.

    Attributes:
        success: Indicates whether document processing completed successfully.
        total_chunks: Number of chunks persisted from the uploaded document.
    """

    success: bool
    total_chunks: int


class LawSearchRequest(BaseModel):
    """Payload for semantic law search requests.

    Attributes:
        prompt: Natural-language query used to generate the search embedding.
        limit: Optional upper bound on the number of results returned.
        max_distance: Optional maximum cosine distance for accepted results.
        source_kind: Optional filter for chunk origin, either ``fragment`` or ``pdf``.
    """

    prompt: str = Field(min_length=1)
    limit: int | None = Field(default=None, ge=1, le=1000)
    max_distance: float | None = Field(default=None, ge=0, le=1)
    source_kind: Literal["fragment", "pdf"] | None = None


class LawChunkSearchResult(BaseModel):
    """Single semantic search hit with law chunk metadata.

    Attributes:
        document_number: Official document identifier of the source law.
        year: Publication year of the source document.
        source_kind: Chunk origin, either ``fragment`` or ``pdf``.
        fragment_id: Unique identifier of the matched fragment.
        depth: Fragment depth in the source hierarchy.
        fragment_type: Fragment type label from the source dataset.
        page_start: First PDF page covered by the chunk.
        page_end: Last PDF page covered by the chunk.
        chunk_index: Chunk order within the source document.
        section_title: Optional section/article title detected during chunking.
        source_filename: Original uploaded filename.
        clean_text: Plain-text fragment content extracted from the source HTML.
        distance: Cosine distance between the query embedding and the fragment.
    """

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


class LawSearchResponse(BaseModel):
    """Semantic search response with summary counts and ordered hits.

    Attributes:
        query: Original query used to generate the semantic search.
        total_results: Number of result rows returned in `results`.
        total_chunks: Number of chunks stored in the database.
        searchable_chunks: Number of chunks that have embeddings and can be searched.
        results: Ordered semantic matches sorted from closest to farthest.
    """

    query: str
    total_results: int
    total_chunks: int
    searchable_chunks: int
    results: list[LawChunkSearchResult]


class FirstAnswerResponse(BaseModel):
    """Response model for the first answer generation."""

    total_chunks: int
    message: str
    map_services: list["MapServiceListItemResponse"] = Field(
        default_factory=list["MapServiceListItemResponse"]
    )


class ChatClientMessage(BaseModel):
    """Incoming chat message from the websocket client."""

    message: str = Field(min_length=1, max_length=4000)


class ChatServerMessage(BaseModel):
    """Outgoing websocket event sent by the server."""

    type: Literal["ready", "assistant", "error"]
    message: str
    total_chunks: int | None = None


class MapServiceListRequest(BaseModel):
    """Query parameters for browsing services on the map API."""

    limit: int = Field(default=25, ge=1, le=100)
    offset: int = Field(default=0, ge=0)

    source_service_id: int | None = Field(default=None, ge=1)
    provider_id: int | None = Field(default=None, ge=1)
    service_type_id: int | None = Field(default=None, ge=1)

    identifier: str | None = Field(default=None, min_length=1)
    q: str | None = Field(default=None, min_length=1)
    municipality: str | None = Field(default=None, min_length=1)
    region: str | None = Field(default=None, min_length=1)

    active_only: bool = True

    lat: float | None = Field(default=None, ge=-90, le=90)
    lon: float | None = Field(default=None, ge=-180, le=180)
    radius_km: float | None = Field(default=None, gt=0, le=1000)

    @model_validator(mode="after")
    def validate_geo_coordinates(self) -> "MapServiceListRequest":
        if (self.lat is None) ^ (self.lon is None):
            raise ValueError("lat and lon must be provided together")

        return self


class MapServiceSearchRequest(BaseModel):
    """Prompt-based search request that will be converted to an embedding."""

    limit: int = Field(default=25, ge=1, le=100)
    offset: int = Field(default=0, ge=0)

    prompt: str = Field(min_length=1)
    lat: float = Field(ge=-90, le=90)
    lon: float = Field(ge=-180, le=180)
    radius_km: float = Field(gt=0, le=1000)


class MapServiceBaseResponse(BaseModel):
    """Shared service fields returned by map endpoints."""

    model_config = ConfigDict(from_attributes=True)

    source_service_id: int
    identifier: str
    provider_id: int
    provider_name: str
    provider_ico: str | None
    service_type_id: int
    active_from: date
    active_to: date | None
    region_scope_by_address: bool


class MapLocationResponse(BaseModel):
    """Service location payload used by map endpoints."""

    model_config = ConfigDict(from_attributes=True)

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


class MapTargetGroupResponse(BaseModel):
    """Service target-group payload used by map endpoints."""

    model_config = ConfigDict(from_attributes=True)

    id: int
    service_id: int
    source_group_id: int
    description: str | None


class MapServiceListItemResponse(MapServiceBaseResponse):
    """A single service row in the map list response."""

    locations_count: int
    target_groups_count: int
    distance_km: float | None = None
    location: MapLocationResponse | None = None


class MapServiceListResponse(BaseModel):
    """Paginated list of services for the map API."""

    limit: int
    offset: int
    total: int
    items: list[MapServiceListItemResponse]


class MapServiceDetailResponse(MapServiceBaseResponse):
    """Full service card with all locations and target groups."""

    locations_count: int
    target_groups_count: int
    locations: list[MapLocationResponse]
    target_groups: list[MapTargetGroupResponse]


class UserFormRequest(BaseModel):
    """Request model for caregiver questionnaire data."""

    # Block 1: "Kdo potřebuje péči?"
    relationship: str = Field(..., description="Vztah k pečované osobě")
    care_recipient_age: int = Field(..., description="Věk pečované osoby")
    care_recipient_gender: str = Field(..., description="Pohlaví pečované osoby")

    # Block 2: "Jak na tom je?"
    self_sufficiency: str = Field(..., description="Míra soběstačnosti")
    has_care_allowance: str = Field(..., description="Má přiznán Příspěvek na péči?")
    situation_duration: str = Field(..., description="Jak dlouho situace trvá?")

    # Block 3: "Jak to máte zařízené?"
    living_arrangement: str = Field(..., description="Kde pečovaná osoba bydlí?")
    postal_code: str = Field(..., description="PSČ bydliště pečované osoby")
    additional_help: list[str] = Field(..., description="Pomáhá ti někdo další?")

    # Block 4: "Tvoje situace"
    employment_status: str = Field(..., description="Pracuješ?")
    main_concerns: list[str] = Field(..., description="Co tě teď nejvíc trápí? (max 2)")

    lat: float | None = Field(default=None, ge=-90, le=90)
    lon: float | None = Field(default=None, ge=-180, le=180)

    @model_validator(mode="after")
    def validate_geo_coordinates(self) -> "UserFormRequest":
        if (self.lat is None) ^ (self.lon is None):
            raise ValueError("lat and lon must be provided together")

        return self
