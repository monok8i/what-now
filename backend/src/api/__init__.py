"""Top-level API router composition for the backend."""

from fastapi import APIRouter

from .endpoints import chat_router, law_router

router = APIRouter(prefix="/api")
router.include_router(chat_router)
router.include_router(law_router)

__all__ = ("router",)
