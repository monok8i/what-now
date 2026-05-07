"""OpenRouter embedding client used for semantic search."""

from typing import List, Sequence

import httpx

from src.infra.ai.exceptions import EmbeddingError


class OpenRouterEmbeddingClient:
    """Generate embeddings through the OpenRouter embeddings endpoint.

    Attributes:
        _api_key: Authentication token used for OpenRouter requests.
        _base_url: Embedding endpoint URL.
        _timeout: Request timeout in seconds.
        _client: Optional shared ``httpx.AsyncClient`` instance.
    """

    def __init__(
        self,
        api_key: str,
        *,
        base_url: str = "https://openrouter.ai/api/v1/embeddings",
        timeout: float = 30.0,
        client: httpx.AsyncClient | None = None,
    ) -> None:
        """Store authentication and transport settings for embedding calls.

        Args:
            api_key: OpenRouter API key.
            base_url: Embedding endpoint URL.
            timeout: Request timeout in seconds.
            client: Optional shared HTTP client.
        """

        self._api_key = api_key
        self._base_url = base_url
        self._timeout = timeout
        self._client = client

    async def generate_embeddings(
        self,
        texts: Sequence[str],
        *,
        model_name: str = "openai/text-embedding-3-small",
    ) -> List[List[float]]:
        """Return embeddings for the supplied texts in input order.

        Args:
            texts: Sequence of input strings to embed.
            model_name: Embedding model identifier to send to OpenRouter.

        Returns:
            Embedding vectors in the same order as ``texts``.

        Raises:
            EmbeddingError: If the OpenRouter request fails or returns invalid
                data.
        """

        if not texts:
            return []

        cleaned_texts = [text.replace("\n", " ") for text in texts]

        payload: dict[str, str | list[str]] = {
            "model": model_name,
            "input": cleaned_texts,
        }

        headers = {
            "Authorization": f"Bearer {self._api_key}",
            "Content-Type": "application/json",
        }

        try:
            if self._client:
                response = await self._client.post(
                    self._base_url,
                    headers=headers,
                    json=payload,
                    timeout=self._timeout,
                )
            else:
                async with httpx.AsyncClient() as client:
                    response = await client.post(
                        self._base_url,
                        headers=headers,
                        json=payload,
                        timeout=self._timeout,
                    )

            response.raise_for_status()
            data = response.json()

            sorted_data = sorted(data["data"], key=lambda x: x["index"])
            return [item["embedding"] for item in sorted_data]

        except httpx.HTTPStatusError as e:
            raise EmbeddingError(
                f"OpenRouter API HTTP error {e.response.status_code}: {e.response.text}"
            ) from e
        except Exception as e:
            raise EmbeddingError(f"OpenRouter API batch embedding error: {e}") from e
