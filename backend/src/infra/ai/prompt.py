"""Prompt templates used by the AI pipeline."""

import json

from src.core.types import SearchChunkResult, SearchResultSet

from .context import (
    BASE_PROMPT,
    GENERATE_ANSWER_PROMPT,
    GENERATE_FORM_PROMPT,
)


def generated_form_prompt(form: dict[str, str | list[str]]) -> str:
    """Generate a compact search prompt from the submitted form data.

    Args:
        form: Structured caregiver questionnaire used to build the query.

    Returns:
        A short Czech user-style prompt for retrieval.
    """

    return "\n\n".join(
        [
            BASE_PROMPT.strip(),
            GENERATE_FORM_PROMPT.strip(),
            json.dumps(form, ensure_ascii=False, indent=2),
        ]
    )


def _serialize_chunk(chunk: SearchChunkResult) -> dict[str, object]:
    text = chunk.clean_text or ""
    if len(text) > 900:
        text = f"{text[:900].rstrip()}..."

    return {
        "document_number": chunk.document_number,
        "year": chunk.year,
        "source_kind": chunk.source_kind,
        "fragment_id": chunk.fragment_id,
        "depth": chunk.depth,
        "fragment_type": chunk.fragment_type,
        "page_start": chunk.page_start,
        "page_end": chunk.page_end,
        "chunk_index": chunk.chunk_index,
        "section_title": chunk.section_title,
        "source_filename": chunk.source_filename,
        "distance": round(chunk.distance, 4),
        "clean_text": text,
    }


def generated_answer_prompt(
    user_query: str,
    search_results: SearchResultSet,
    *,
    max_sources: int = 8,
) -> str:
    """Build the answer prompt from the user query and retrieved sources."""

    sources = [
        _serialize_chunk(chunk) for chunk in search_results.results[:max_sources]
    ]

    return "\n\n".join(
        [
            BASE_PROMPT.strip(),
            GENERATE_ANSWER_PROMPT.strip(),
            f"USER QUERY:\n{user_query}",
            f"RETRIEVED SOURCES (showing up to {max_sources} of {len(search_results.results)}):\n"
            + json.dumps(sources, ensure_ascii=False, indent=2),
            "RULES: Use the source metadata in the answer. Prefer short citations like 'Zákon 108/2006 Sb.' or 'Sb. 108/2006, s. X'. Do not invent missing source details.",
        ]
    )
