"""Route group exports for the API endpoints package."""

from .data import router as data_router
from .law import router as law_router


__all__ = ("data_router", "law_router")
