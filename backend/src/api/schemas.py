"""API schemas for data validation."""

from pydantic import BaseModel


class LawUploadResponse(BaseModel):
    success: bool
    total_chunks: int
