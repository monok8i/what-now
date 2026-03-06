#!/bin/sh

set -e

# Apply database migrations
alembic upgrade head

# Start the FastAPI application with Uvicorn
uvicorn main:create_app --factory --reload --host 0.0.0.0 --port 8001