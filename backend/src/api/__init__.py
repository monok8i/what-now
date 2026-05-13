"""Top-level API router composition for the backend."""

from fastapi import APIRouter

from .endpoints.chat import router as chat_router
from .endpoints.answer import router as answer_router
from .endpoints.law import router as law_router
from .endpoints.map import router as map_router

router = APIRouter(prefix="/api/v1")
router.include_router(chat_router)
router.include_router(answer_router)
router.include_router(law_router)
router.include_router(map_router)

__all__ = ("router",)
