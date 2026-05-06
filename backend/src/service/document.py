import json
from itertools import islice
from typing import TYPE_CHECKING, Generator

from src.utils.html_parser.parser import extract_text_from_html
from src.infra.db.types import LawChunkType

if TYPE_CHECKING:
    from src.infra.ai.embedding.client import OpenRouterEmbeddingClient
    from src.infra.db.repository import LawChunkRepository


def batched[T](iterable: list[T], n: int) -> Generator[list[T], None, None]:
    """Batch data into lists of length n."""

    it = iter(iterable)
    while batch := list(islice(it, n)):
        yield batch


class DocumentProcessorService:
    EMBEDDING_BATCH_SIZE = 100

    def __init__(
        self,
        embedding_client: "OpenRouterEmbeddingClient",
        repository: "LawChunkRepository",
    ) -> None:
        self._embedding_client = embedding_client
        self._repository = repository

    async def process_document(self, file_content: bytes) -> int:
        try:
            data = json.loads(file_content.decode("utf-8"))
        except json.JSONDecodeError as e:
            raise ValueError(f"Invalid JSON file: {e}")

        metadata = data.get("metadata", {})
        fragmenty = data.get("fragmenty", [])

        document_number = metadata.get("predpisCislo")
        year = metadata.get("rocnik")

        records_to_insert: list[LawChunkType] = []

        texts_to_embed: list[str] = []
        indices_needing_embedding: list[int] = []

        for idx, frag in enumerate(fragmenty):
            xhtml_content = frag.get("xhtml")
            clean_text = (
                extract_text_from_html(xhtml_content) if xhtml_content else None
            )

            record = LawChunkType(
                document_number=document_number,
                year=year,
                fragment_id=frag.get("fragmentId"),
                depth=frag.get("hloubka"),
                fragment_type=frag.get("typ"),
                clean_text=clean_text,
                embedding=None,
            )
            records_to_insert.append(record)

            if clean_text and clean_text.strip():
                texts_to_embed.append(clean_text)
                indices_needing_embedding.append(idx)

        all_embeddings: list[list[float]] = []
        for batch_texts in batched(texts_to_embed, self.EMBEDDING_BATCH_SIZE):
            emb_batch = await self._embedding_client.generate_embeddings(batch_texts)
            all_embeddings.extend(emb_batch)

        for record_idx, embedding in zip(indices_needing_embedding, all_embeddings):
            records_to_insert[record_idx]["embedding"] = embedding

        inserted_count = await self._repository.save_chunks(records_to_insert)

        return inserted_count
