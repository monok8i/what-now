#!/bin/sh

set -e

# Apply database migrations
echo "Running Alembic migrations..."
if alembic upgrade head; then
  echo "✓ Migrations completed successfully"
else
  echo "✗ Migration failed"
  exit 1
fi

echo "Starting FastAPI server..."

# Start the FastAPI application with Uvicorn
python main.py