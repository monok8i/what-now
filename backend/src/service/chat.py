"""Chat service used by the websocket endpoint."""

from typing import TYPE_CHECKING

from src.core.types import ChatReplyResult
from src.infra.ai.prompt import (
    generated_chat_answer_prompt,
    generated_chat_query_prompt,
)

if TYPE_CHECKING:
    from src.infra.ai.client import GemmaChatClient
    from .search import SearchService


class ChatService:
    """Answer chat turns with retrieval-augmented context."""

    SEARCH_LIMIT = 8
    MAX_DISTANCE = 0.45
    MAX_HISTORY_TURNS = 6

    def __init__(
        self,
        ai_client: "GemmaChatClient",
        search_service: "SearchService",
    ) -> None:
        self._ai_client = ai_client
        self._search_service = search_service

    async def reply(
        self,
        user_message: str,
        history: list[dict[str, str]] | None = None,
    ) -> ChatReplyResult:
        """Generate a chat reply grounded in retrieved legal sources."""

        conversation = history or []
        search_query_prompt = generated_chat_query_prompt(
            user_message,
            conversation,
            max_turns=self.MAX_HISTORY_TURNS,
        )

        search_result_set = await self._search_service.search(
            prompt=search_query_prompt,
            limit=self.SEARCH_LIMIT,
            max_distance=self.MAX_DISTANCE,
        )

        answer_prompt = generated_chat_answer_prompt(
            user_message,
            conversation,
            search_result_set,
            max_turns=self.MAX_HISTORY_TURNS,
        )

        response = await self._ai_client.chat(answer_prompt)

        return ChatReplyResult(
            total_chunks=len(search_result_set.results),
            message=response,
        )
