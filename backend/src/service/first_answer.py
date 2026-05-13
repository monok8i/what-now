"""First-answer generation service for the caregiver intake form."""

from typing import TYPE_CHECKING

from src.core.types import FirstAnswerResult
from src.infra.ai.prompt import generated_answer_prompt, generated_form_prompt

if TYPE_CHECKING:
    from src.infra.ai.client import GemmaChatClient
    from src.api.schemas import UserFormRequest
    from .search import SearchService
    from src.infra.db.repository.service import ServiceRepository
    from src.infra.embeddings.client import SentenceTransformerEmbeddingClient


class FirstAnswerService:
    """Turn a submitted form into a searched, source-backed AI response."""

    SEARCH_LIMIT = 8
    MAX_DISTANCE = 0.3
    MAP_SEARCH_LIMIT = 8
    MAP_SEARCH_RADIUS_KM = 10.0

    def __init__(
        self,
        ai_client: "GemmaChatClient",
        search_service: "SearchService",
        embedding_client: "SentenceTransformerEmbeddingClient",
        service_repository: "ServiceRepository",
    ) -> None:
        self._ai_client = ai_client
        self._search_service = search_service
        self._embedding_client = embedding_client
        self._service_repository = service_repository

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

        map_services = []
        query_embedding = await self._embedding_client.generate_embeddings(
            [user_query_prompt]
        )
        if query_embedding:
            if user_form.lat is not None and user_form.lon is not None:
                map_result_set = (
                    await self._service_repository.search_services_by_embedding(
                        embedding=query_embedding[0],
                        limit=self.MAP_SEARCH_LIMIT,
                        offset=0,
                        lat=user_form.lat,
                        lon=user_form.lon,
                        radius_km=self.MAP_SEARCH_RADIUS_KM,
                    )
                )
            else:
                map_result_set = (
                    await self._service_repository.search_services_by_embedding(
                        embedding=query_embedding[0],
                        limit=self.MAP_SEARCH_LIMIT,
                        offset=0,
                    )
                )
            map_services = map_result_set.items

        return FirstAnswerResult(
            message=response,
            total_chunks=len(search_result_set.results),
            map_services=map_services,
        )
