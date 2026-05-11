"""HTTP client for chatting with the configured AI model."""

import httpx

from .exceptions import AIClientError


class GemmaChatClient:
    """Send chat requests to the configured Gemma-compatible API."""

    def __init__(
        self,
        *,
        model_name: str,
        server_url: str,
        request_timeout: float = 60.0,
    ) -> None:
        """
        Store the chat endpoint configuration.

        Args:
            model_name: Model identifier accepted by the server.
            server_url: Chat completion endpoint URL.
            request_timeout: Request timeout in seconds.
        """

        self._model_name = model_name
        self._server_url = server_url
        self._client = httpx.AsyncClient(timeout=request_timeout)

    async def chat(self, prompt: str) -> str:
        """
        Send a prompt to the model and return the assistant response.

        Args:
            prompt: User input string to send to the model.

        Returns:
            The assistant's response string.

        """

        payload: dict[str, object] = {
            "model": self._model_name,
            "messages": [
                {
                    "role": "user",
                    "content": prompt,
                }
            ],
            "stream": False,
        }

        try:
            response = await self._client.post(self._server_url, json=payload)
            response.raise_for_status()

            data = response.json()
            return data["message"]["content"]
        except (httpx.HTTPError, KeyError, ValueError) as e:
            raise AIClientError(f"Chat request failed: {e}") from e

    async def aclose(self) -> None:
        """Close the underlying HTTP client."""

        await self._client.aclose()
