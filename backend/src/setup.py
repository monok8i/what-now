"""Application setup helpers for building the FastAPI server."""

import uvicorn
from fastapi import FastAPI

from src.api import router as api_router
from src.api.events.lifespan import lifespan
from src.config._global import config


def create_fastapi() -> FastAPI:
    """Create the FastAPI application and register shared state and routers.

    Returns:
        Configured FastAPI application instance.
    """

    app = FastAPI(title="What Now API", lifespan=lifespan)
    app.state.project_config = config

    app.include_router(api_router)

    return app


def create_api_server() -> uvicorn.Server:
    """Build the Uvicorn server wrapper around the FastAPI application.

    Returns:
        Configured Uvicorn server instance.
    """

    app = create_fastapi()

    return uvicorn.Server(
        uvicorn.Config(
            app=app,
            host=config.api.API_HOST,
            port=config.api.API_PORT,
            log_config=None,
        )
    )


async def run_fastapi(server: uvicorn.Server) -> None:
    """Run the FastAPI application in the current event loop.

    Args:
        server: Configured Uvicorn server instance.
    """

    await server.serve()


def stop_fastapi(server: uvicorn.Server) -> None:
    """Request a graceful shutdown of the FastAPI server.

    Args:
        server: Configured Uvicorn server instance.
    """

    server.should_exit = True
