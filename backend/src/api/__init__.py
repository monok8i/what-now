from fastapi import APIRouter

from .endpoints import data_router, law_router

router = APIRouter(prefix="/api")
router.include_router(data_router)
router.include_router(law_router)

__all__ = ("router",)
