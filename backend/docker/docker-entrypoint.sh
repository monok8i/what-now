#!/bin/sh

set -e

# Apply database migrations
# alembic upgrade head

# Start the FastAPI application with Uvicorn
python main.py