"""Typed structures shared by the database layer."""

from typing import NotRequired, TypedDict


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
