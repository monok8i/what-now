"""Embedding service."""

from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from openai import AsyncOpenAI

from src.infra.ai.exceptions import EmbeddingError


async def generate_embedding(
    text: str, *, client: "AsyncOpenAI", model_name: str = "text-embedding-3-small"
) -> list[float]:
    """Generate an embedding vector for the given text using OpenAI API."""

    try:
        cleaned_text = text.replace("\n", " ")

        response = await client.embeddings.create(
            input=[cleaned_text], model=model_name
        )
        return response.data[0].embedding

    except Exception as e:
        raise EmbeddingError(f"OpenAI API error: {e}") from e
