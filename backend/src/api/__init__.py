from fastapi import APIRouter

from .endpoints import data_router

router = APIRouter(prefix="/api")
router.include_router(data_router)

__all__ = ("router",)
