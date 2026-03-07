# Hackujstat 2026 - Backend

FastAPI application with AI-powered questionnaire processing, WebSocket chat, and PostgreSQL database for matching caregivers with social benefits.

## Configuration

Create `.env` file in the `backend/` directory (copy from `.env.example`):

```bash
# Database
POSTGRES_USER=backend
POSTGRES_PASSWORD=secret
POSTGRES_HOST=localhost         # For Docker: use 'backend-db' or your container/service name based on docker-compose.yml
POSTGRES_PORT=5432
POSTGRES_DB=hackujstat

# AI (Required)
OPENROUTER_API_KEY=sk-or-...   # Your OpenRouter API key
OPENROUTER_AI_MODEL="google/gemini-2.5-flash-lite-preview-09-2025"
```

## Getting Started with Docker Compose

### Prerequisites

- Docker installed
- `.env` file configured in the backend directory

### Starting the Service

From the project root directory:
Quick Start

### With Docker Compose (Recommended)

```bash
# From project root
docker compose up backend backend-db --build
```

Migrations run automatically on startup.

```bash
# # Without Docker (Local Development)

```bash
cd backend

# Install dependencies
uv sync

# Setup database (PostgreSQL must be running)
# Set database host to localhost in .env file
POSTGRES_HOST=localhost

# Run migrations
alembic upgrade head

# Set database host back to your value

# Start server
uvicorn main:create_app --factory --reload --host 0.0.0.0 --port 8001
```

API: http://localhost:8001/docs

## Dataset Scheduler

An automated task scheduler downloads datasets daily from external sources:

- **ČSSZ & NKOD**: CSV files (saved to `datasets/`)
- **RPSS**: Full sync - download → process → load to database
- **Schedule:** Daily at 3:00 AM + on startup
- **Logs:** `docker-compose logs -f scheduler`

See [../SCHEDULER.md](../SCHEDULER.md) for details.

## Database Migrations

```bash
# Create new migration (after model changes)
alembic revision --autogenerate -m "Description"

# Apply migrations
alembic upgrade head

# Rollback
alembic downgrade -1
```
