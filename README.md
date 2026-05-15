# What Now? (Co teď?)

AI-powered web platform for people caring for an elderly or ill loved one.

The project combines:

- guided intake form,
- legal-information retrieval (RAG),
- AI-generated personalized recommendations,
- interactive map of nearby social services.

## Why This Project Exists

When caregiving starts suddenly, people usually do not know:

- what support they are entitled to,
- what practical steps to take first,
- which services are available nearby.

What Now helps users move from uncertainty to an actionable plan in a few minutes.

## Product Workflow (End-to-End)

1. User opens frontend and fills a 4-step caregiving questionnaire.
2. Frontend sends form data to backend endpoint `POST /api/v1/answer`.
3. Backend converts answers into a compact retrieval query.
4. Backend performs semantic search over indexed legal chunks in PostgreSQL + pgvector.
5. Backend asks AI model for a grounded response based on retrieved sources.
6. Backend finds relevant social services (semantic + optional geo-radius filter).
7. Frontend renders the response (Markdown) and service map (Leaflet).
8. User can continue in chat (`POST /api/v1/chat/message` or WebSocket `/api/v1/chat/ws`).

## High-Level Architecture

### Frontend (Next.js)

- Multi-step form (`/pomoc`)
- Result view with AI response and map modal
- Dedicated map page (`/mapa`)
- Responsive UI for desktop and mobile

### Backend (FastAPI)

- Laws ingestion and chunk indexing (JSON/PDF)
- Semantic search over legal text
- First-answer generation from form data
- Chat endpoint (HTTP + WebSocket)
- Social-service filtering and semantic matching

### Data Layer

- PostgreSQL 16
- pgvector extension for embedding similarity
- Alembic migrations
- Main entities: law chunks, social services, service locations, target groups

## Technology Stack

### Frontend

- Next.js 16.1.6
- React 19.2.3
- TypeScript 5
- Tailwind CSS 4
- @tailwindcss/typography
- Leaflet 1.9.4
- React Leaflet 5.0.0
- react-markdown + remark-gfm
- Lucide React
- ESLint 9

### Backend

- Python 3.13+
- FastAPI (async API)
- Uvicorn
- SQLAlchemy 2 (async)
- asyncpg
- pgvector
- Alembic
- Pydantic + pydantic-settings
- httpx
- OpenAI-compatible client (`openai` package)
- sentence-transformers
- pypdf

### Infrastructure / Tooling

- Docker + Docker Compose
- uv (Python package/dependency manager)
- PostgreSQL image: `pgvector/pgvector:0.6.0-pg16`

### Optional/Experimental Parts in Repository

- `tasks/` service (Celery, Playwright, RabbitMQ) prepared for async parsing workflows
- Services are currently commented out in `docker-compose.yml` and are not part of the default runtime
- `_gemma4/` scripts in backend are experimental CLI utilities

## Repository Structure

```text
what-now/
├── docker-compose.yml
├── frontend/                  # Next.js application
├── backend/                   # FastAPI application
├── tasks/                     # Optional task workers (currently not active in compose)
└── test_docker.sh             # Convenience script for compose validation/start
```

## API Overview

Base prefix: `/api/v1`

- `GET /laws/health` - laws slice health check
- `POST /laws/` - upload/index law documents
- `GET /laws/` - semantic law search
- `POST /answer` - first personalized answer from intake form
- `POST /chat/message` - one-shot chat response
- `WS /chat/ws` - realtime chat channel
- `GET /map/services` - paginated map services with filters
- `GET /map/services/{source_service_id}` - service detail
- `POST /map/services/search` - semantic + geo service search

## Quick Start (Docker)

### 1. Prerequisites

- Docker + Docker Compose
- API credentials and model configuration for backend AI endpoint

### 2. Configure environment

Create backend environment file:

```bash
cp backend/.env.example backend/.env
```

If `.env.example` is not present, create `backend/.env` manually and provide at least:

```bash
# API
API_HOST=0.0.0.0
API_PORT=8001

# Database
POSTGRES_USER=backend
POSTGRES_PASSWORD=secret
POSTGRES_HOST=backend-db
POSTGRES_PORT=5432
POSTGRES_DB=whatnow

# AI
AI_MODEL_NAME=your-model-name
AI_SERVER_URL=https://your-ai-endpoint
AI_REQUEST_TIMEOUT=60
```

### 3. Run containers

```bash
docker compose --env-file backend/.env up -d --build
```

### 4. Open services

- Frontend: `http://localhost:3000`
- Backend API docs: `http://localhost:8001/docs`

### 5. Stop environment

```bash
docker compose --env-file backend/.env down
```

## Local Development (Without Docker)

### Backend

```bash
cd backend
uv sync
source .venv/bin/activate
alembic upgrade head
python main.py
```

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## Data & Search Notes

- Legal text is chunked and stored with embeddings.
- Query and chunk vectors are compared using cosine distance in pgvector.
- Social-service matching combines semantic similarity with optional location radius.
- If user location is missing, semantic matching still works without geo filtering.

## Current Scope and Limitations

- Primary product language is Czech.
- AI quality depends on configured external AI server/model.
- No active scheduler runtime flow is currently wired into backend runtime path.

## Additional Documentation

- Frontend details: `frontend/README.md`
- Backend details: `backend/README.md`

# License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.