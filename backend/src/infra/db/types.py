from typing import TypedDict


class LawChunkType(TypedDict):
    document_number: str
    year: int
    fragment_id: str
    depth: int
    fragment_type: str
    clean_text: str | None
    embedding: list[float] | None
