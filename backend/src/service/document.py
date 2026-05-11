"""Document ingestion service for law JSON and PDF files.

This module turns uploaded JSON and PDF documents into searchable database
chunks by extracting text, batching embeddings, and saving the results.
"""

import io
import json
import re
from itertools import islice
from pathlib import Path
from typing import TYPE_CHECKING, Generator

from pypdf import PdfReader

from src.utils.html_parser.parser import extract_text_from_html
from src.utils.text import remove_diacritics
from src.core.exceptions import (
    EncryptedPdfDocumentError,
    InvalidJsonDocumentError,
    InvalidPdfDocumentError,
    PdfMetadataExtractionError,
)
from src.infra.db.types import LawChunkType

if TYPE_CHECKING:
    from src.infra.db.repository import LawChunkRepository
    from src.infra.embeddings.client import SentenceTransformerEmbeddingClient


def batched[T](iterable: list[T], n: int) -> Generator[list[T], None, None]:
    """Yield successive chunks of size ``n`` from a list.

    Args:
        iterable: List of items to split into smaller batches.
        n: Maximum number of items per batch.

    Yields:
        Batches of items from ``iterable`` with at most ``n`` elements.
    """

    it = iter(iterable)
    while batch := list(islice(it, n)):
        yield batch


class DocumentProcessorService:
    """Parse uploaded documents and persist searchable law chunks.

    The service accepts a law JSON payload, extracts plain text from fragments,
    batches embedding generation, and saves the final rows through the
    repository layer.

    Attributes:
        EMBEDDING_BATCH_SIZE: Maximum number of texts embedded in one request.
    """

    EMBEDDING_BATCH_SIZE = 100
    PDF_CHUNK_MAX_CHARS = 2000
    PDF_CHUNK_OVERLAP_CHARS = 250

    def __init__(
        self,
        embedding_client: "SentenceTransformerEmbeddingClient",
        repository: "LawChunkRepository",
    ) -> None:
        """Store the embedding client and repository used during ingestion.

        Args:
            embedding_client: Client used to generate text embeddings.
            repository: Repository used to persist processed chunks.
        """

        self._embedding_client = embedding_client
        self._repository = repository

    async def process_json_document(
        self,
        file_content: bytes,
        *,
        filename: str | None = None,
    ) -> int:
        """Parse one uploaded JSON document and store its chunks.

        Args:
            file_content: Raw UTF-8 encoded JSON payload from the upload.

        Returns:
            Number of chunks inserted into the database.

        Raises:
            ValueError: If ``file_content`` is not valid JSON.
        """

        try:
            data = json.loads(file_content.decode("utf-8"))
        except json.JSONDecodeError as e:
            raise InvalidJsonDocumentError(f"Invalid JSON file: {e}") from e

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
                source_kind="fragment",
                fragment_id=frag.get("fragmentId"),
                depth=frag.get("hloubka"),
                fragment_type=frag.get("typ"),
                page_start=None,
                page_end=None,
                chunk_index=idx + 1,
                section_title=None,
                source_filename=filename,
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

    async def process_pdf_document(
        self,
        file_content: bytes,
        *,
        filename: str | None = None,
    ) -> int:
        """Parse one uploaded PDF document and store chunked text rows.

        Args:
            file_content: Raw PDF bytes from the upload.
            filename: Optional original filename used for metadata extraction.

        Returns:
            Number of chunks inserted into the database.

        Raises:
            ValueError: If the PDF cannot be decoded or required metadata is
                missing.
        """

        try:
            reader = PdfReader(io.BytesIO(file_content))
        except Exception as e:
            raise InvalidPdfDocumentError(f"Invalid PDF file: {e}") from e

        if reader.is_encrypted:
            try:
                reader.decrypt("")
            except Exception as e:
                raise EncryptedPdfDocumentError(
                    f"Encrypted PDF file is not supported: {e}"
                ) from e

        document_number, year = self._extract_pdf_metadata(reader, filename)

        records_to_insert: list[LawChunkType] = []
        texts_to_embed: list[str] = []
        indices_needing_embedding: list[int] = []

        chunk_index = 0
        for page_number, page in enumerate(reader.pages, start=1):
            raw_text = page.extract_text() or ""
            for chunk_text in self._chunk_pdf_text(raw_text):
                chunk_index += 1
                record = LawChunkType(
                    document_number=document_number,
                    year=year,
                    source_kind="pdf",
                    fragment_id=None,
                    depth=None,
                    fragment_type=None,
                    page_start=page_number,
                    page_end=page_number,
                    chunk_index=chunk_index,
                    section_title=None,
                    source_filename=filename,
                    clean_text=chunk_text,
                    embedding=None,
                )
                records_to_insert.append(record)

                if chunk_text.strip():
                    texts_to_embed.append(chunk_text)
                    indices_needing_embedding.append(len(records_to_insert) - 1)

        all_embeddings: list[list[float]] = []
        for batch_texts in batched(texts_to_embed, self.EMBEDDING_BATCH_SIZE):
            emb_batch = await self._embedding_client.generate_embeddings(batch_texts)
            all_embeddings.extend(emb_batch)

        for record_idx, embedding in zip(indices_needing_embedding, all_embeddings):
            records_to_insert[record_idx]["embedding"] = embedding

        inserted_count = await self._repository.save_chunks(records_to_insert)

        return inserted_count

    def _extract_pdf_metadata(
        self,
        reader: PdfReader,
        filename: str | None,
    ) -> tuple[str, int]:
        """Derive official document metadata from the filename or PDF text."""

        if filename:
            stem = Path(filename).stem
            match = re.search(r"Sb_(\d{4})_(\d+)", stem)
            if match:
                year = int(match.group(1))
                number = int(match.group(2))
                return f"{number}/{year} Sb.", year

        first_pages_text = "\n".join(
            (reader.pages[idx].extract_text() or "")
            for idx in range(min(2, len(reader.pages)))
        )

        official_number_match = re.search(r"(\d+/\d{4}\s+Sb\.)", first_pages_text)
        if official_number_match:
            document_number = official_number_match.group(1)
            year_match = re.search(r"/(\d{4})\s+Sb\.", document_number)
            if year_match:
                return document_number, int(year_match.group(1))

        raise PdfMetadataExtractionError(
            "Unable to determine document metadata for PDF ingestion. Provide a "
            "filename like 'Sb_2006_108_...pdf' or extract an official number "
            "from the first PDF pages."
        )

    def _chunk_pdf_text(self, text: str) -> list[str]:
        """Split extracted PDF text into overlapping chunks."""

        normalized_text = remove_diacritics(re.sub(r"\s+", " ", text)).strip()
        if not normalized_text:
            return []

        if len(normalized_text) <= self.PDF_CHUNK_MAX_CHARS:
            return [normalized_text]

        chunks: list[str] = []
        start = 0
        text_length = len(normalized_text)

        while start < text_length:
            end = min(text_length, start + self.PDF_CHUNK_MAX_CHARS)
            if end < text_length:
                split_at = normalized_text.rfind(" ", start, end)
                if split_at <= start:
                    split_at = end
                end = split_at

            chunk = normalized_text[start:end].strip()
            if chunk:
                chunks.append(chunk)

            if end >= text_length:
                break

            start = max(0, end - self.PDF_CHUNK_OVERLAP_CHARS)
            while start < text_length and normalized_text[start].isspace():
                start += 1

        return chunks
