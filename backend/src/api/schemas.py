"""API schemas for data validation."""

from pydantic import BaseModel, Field


class LawUploadResponse(BaseModel):
    success: bool
    total_chunks: int


class LawSearchRequest(BaseModel):
    prompt: str = Field(min_length=1)
    limit: int | None = Field(default=None, ge=1, le=1000)


class LawChunkSearchResult(BaseModel):
    document_number: str
    year: int
    fragment_id: int
    depth: int
    fragment_type: str
    clean_text: str | None
    distance: float


class LawSearchResponse(BaseModel):
    query: str
    total_results: int
    results: list[LawChunkSearchResult]
