"""First-answer generation service for the caregiver intake form."""

from typing import TYPE_CHECKING

from src.core.types import FirstAnswerResult
from src.infra.ai.prompt import generated_answer_prompt, generated_form_prompt

if TYPE_CHECKING:
    from src.infra.ai.client import GemmaChatClient
    from src.api.schemas import UserFormRequest
    from .search import SearchService


class FirstAnswerService:
    """Turn a submitted form into a searched, source-backed AI response."""

    SEARCH_LIMIT = 8
    MAX_DISTANCE = 0.3

    def __init__(
        self, ai_client: "GemmaChatClient", search_service: "SearchService"
    ) -> None:
        self._ai_client = ai_client
        self._search_service = search_service

    async def first_answer(self, user_form: "UserFormRequest") -> FirstAnswerResult:
        """Search documents from the generated form prompt and answer from them."""

        user_query_prompt = generated_form_prompt(user_form.model_dump())

        search_result_set = await self._search_service.search(
            prompt=user_query_prompt,
            limit=self.SEARCH_LIMIT,
            max_distance=self.MAX_DISTANCE,
        )

        answer_prompt = generated_answer_prompt(
            user_query=search_result_set.query,
            search_results=search_result_set,
        )

        response = await self._ai_client.chat(answer_prompt)

        return FirstAnswerResult(
            message=response, total_chunks=len(search_result_set.results)
        )
