"""Semantic search service for law chunks."""

from typing import TYPE_CHECKING

from src.core.types import SearchChunkResult, SearchResultSet
from src.core.exceptions import SearchServiceError

if TYPE_CHECKING:
    from src.infra.db.repository import LawChunkRepository
    from src.infra.embeddings.client import SentenceTransformerEmbeddingClient


class SearchService:
    """Orchestrate embedding generation and chunk retrieval."""

    def __init__(
        self,
        embedding_client: "SentenceTransformerEmbeddingClient",
        repository: "LawChunkRepository",
    ) -> None:
        self._embedding_client = embedding_client
        self._repository = repository

    async def search(
        self,
        *,
        prompt: str,
        limit: int | None = None,
        max_distance: float | None = None,
        source_kind: str | None = None,
    ) -> SearchResultSet:
        """Return ranked chunk hits for the supplied prompt."""

        try:
            total_chunks = await self._repository.count_chunks(
                source_kind=source_kind,
            )
            searchable_chunks = await self._repository.count_chunks(
                indexed_only=True,
                source_kind=source_kind,
            )

            query_embedding = await self._embedding_client.generate_embeddings([prompt])
            if not query_embedding:
                return SearchResultSet(
                    query=prompt,
                    total_chunks=total_chunks,
                    searchable_chunks=searchable_chunks,
                    results=[],
                )

            chunks = await self._repository.find_relevant_chunks(
                query_embedding[0],
                limit=limit,
                max_distance=max_distance,
                source_kind=source_kind,
            )

            results = [
                SearchChunkResult(
                    document_number=chunk.document_number,
                    year=chunk.year,
                    source_kind=chunk.source_kind,
                    fragment_id=chunk.fragment_id,
                    depth=chunk.depth,
                    fragment_type=chunk.fragment_type,
                    page_start=chunk.page_start,
                    page_end=chunk.page_end,
                    chunk_index=chunk.chunk_index,
                    section_title=chunk.section_title,
                    source_filename=chunk.source_filename,
                    clean_text=chunk.clean_text,
                    distance=distance,
                )
                for chunk, distance in chunks
            ]

            return SearchResultSet(
                query=prompt,
                total_chunks=total_chunks,
                searchable_chunks=searchable_chunks,
                results=results,
            )
        except Exception as e:
            raise SearchServiceError(f"Search pipeline failed: {e}") from e
