"""Typed structures shared by the database layer."""

from typing import TypedDict


class LawChunkType(TypedDict):
    """Shape of a law chunk before it is converted into an ORM model.

    Attributes:
        document_number: Official document identifier of the source law.
        year: Publication year of the source document.
        fragment_id: Unique identifier of the source fragment.
        depth: Fragment depth in the source hierarchy.
        fragment_type: Fragment type label from the source dataset.
        clean_text: Plain-text content extracted from the source HTML.
        embedding: Optional embedding vector generated for the fragment text.
    """

    document_number: str
    year: int
    fragment_id: str
    depth: int
    fragment_type: str
    clean_text: str | None
    embedding: list[float] | None
