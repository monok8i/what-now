"""Pydantic models used by the API request and response payloads."""

from typing import Literal

from pydantic import BaseModel, Field


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
