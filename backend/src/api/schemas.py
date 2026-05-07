"""Pydantic models used by the API request and response payloads."""

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
    """

    prompt: str = Field(min_length=1)
    limit: int | None = Field(default=None, ge=1, le=1000)
    max_distance: float | None = Field(default=None, ge=0, le=2)


class LawChunkSearchResult(BaseModel):
    """Single semantic search hit with law chunk metadata.

    Attributes:
        document_number: Official document identifier of the source law.
        year: Publication year of the source document.
        fragment_id: Unique identifier of the matched fragment.
        depth: Fragment depth in the source hierarchy.
        fragment_type: Fragment type label from the source dataset.
        clean_text: Plain-text fragment content extracted from the source HTML.
        distance: Cosine distance between the query embedding and the fragment.
    """

    document_number: str
    year: int
    fragment_id: int
    depth: int
    fragment_type: str
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
