"""Answer endpoint for the caregiver intake form."""

from typing import Annotated

from fastapi import APIRouter, Body, status

from src.api.depends import FirstAnswerServiceDependency
from src.api.schemas import (
    FirstAnswerResponse,
    UserFormRequest,
)
from src.api.exceptions import SearchError
from src.api.utils import build_map_item_payload

router = APIRouter(tags=["answers"])


@router.post(
    "/answer", response_model=FirstAnswerResponse, status_code=status.HTTP_200_OK
)
async def first_answer(
    user_form: Annotated[UserFormRequest, Body(...)],
    answer_service: FirstAnswerServiceDependency,
):
    """Generate the first AI answer and, when available, nearby services."""

    try:
        result = await answer_service.first_answer(user_form)
    except Exception as e:
        raise SearchError(detail=str(e)) from e

    return FirstAnswerResponse(
        total_chunks=result.total_chunks,
        message=result.message,
        map_services=[build_map_item_payload(record) for record in result.map_services],
    )
