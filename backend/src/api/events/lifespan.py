"""Lifespan event handler for the API."""

from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager
from typing import TYPE_CHECKING

if TYPE_CHECKING:
    from fastapi import FastAPI


@asynccontextmanager
async def lifespan(app: "FastAPI") -> AsyncGenerator[None]:
    """Lifespan event handler for the API."""
    yield
