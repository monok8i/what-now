"""Main entry point for the application."""

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.api import router as api_router


def create_app() -> FastAPI:
    app = FastAPI()
    app.include_router(api_router)

    app.add_middleware(
        CORSMiddleware,
        allow_origins=["*"],
        allow_credentials=False,
        allow_methods=["*"],
        allow_headers=["*"],
    )

    return app
