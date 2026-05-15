# What Now - Backend

FastAPI backend service for:

- RAG search over legal documents (JSON fragments and PDF files),
- first-answer generation for the caregiver intake form,
- chat interaction over HTTP and WebSocket,
- social-service search using filters, geo-distance, and semantic relevance,
- PostgreSQL + pgvector data storage and retrieval.

## 1. What the System Does

The service combines three core domains:

1. Legal knowledge
   - law upload,
   - chunking,
   - embedding generation,
   - semantic retrieval of relevant fragments.
2. User support
   - first AI answer generation from the intake form,
   - ongoing chat with source-grounded context.
3. Social services map
   - filtered service listing,
   - detailed service card,
   - semantic target-group matching plus geo-radius filtering.

## 2. Project Architecture

### Entry Point and Bootstrap

- `main.py`
  - starts the server via `src.setup.create_api_server()`,
  - registers `SIGTERM`/`SIGINT` handlers for graceful shutdown,
  - initializes and stops logging.

- `src/setup.py`
  - creates the FastAPI application,
  - configures CORS,
  - registers routers,
  - wraps the app in `uvicorn.Server`.

- `src/api/events/lifespan.py`
  - creates a singleton `SentenceTransformerEmbeddingClient` on startup
    and stores it in `app.state`.

### Layers

- `src/api/`
  - HTTP/WebSocket endpoints,
  - Pydantic request/response schemas,
  - DI dependencies (`depends.py`),
  - API exceptions.

- `src/service/`
  - business logic:
    - `document.py`: document ingestion,
    - `search.py`: semantic search,
    - `first_answer.py`: first answer + map matching,
    - `chat.py`: chat with retrieval context.

- `src/infra/`
  - integrations:
    - `ai/`: HTTP client to the AI server + prompt templates,
    - `embeddings/`: SentenceTransformer client,
    - `db/`: SQLAlchemy models, repositories, sessions.

- `src/core/`
  - global configuration (`core/config`),
  - shared types and domain exceptions.

- `src/utils/`
  - HTML-to-text parsing,
  - text normalization,
  - logging,
  - geo import/data preparation scripts.

## 3. Application Lifecycle

1. `python main.py`
2. `setup_logging()` configures queue-based logging.
3. `create_api_server()` builds FastAPI + Uvicorn.
4. Lifespan startup initializes the embedding model in-process.
5. Requests are handled via DI (`src/api/depends.py`) and async DB sessions.
6. On shutdown, `server.should_exit = True` is set and logging is stopped.

## 4. API Surface

Base API prefix: `/api/v1`

### 4.1 Laws

- `GET /api/v1/laws/health`
  - health check for the laws API slice.

- `POST /api/v1/laws/`
  - uploads a law document (JSON or PDF),
  - uses `DocumentProcessorService`,
  - response: `LawUploadResponse` (`success`, `total_chunks`).

- `GET /api/v1/laws/`
  - semantic search,
  - query parameters:
    - `prompt` (required),
    - `limit` (1..1000),
    - `max_distance` (0..1),
    - `source_kind` (`fragment` | `pdf`).

### 4.2 First Answer

- `POST /api/v1/answer`
  - accepts `UserFormRequest` (caregiver form + optional `lat/lon`),
  - generates the first AI answer,
  - returns:
    - `message`,
    - `total_chunks`,
    - `map_services` (relevant services).

### 4.3 Chat

- `POST /api/v1/chat/message`
  - single-turn chat reply (useful for Swagger/simple clients).

- `WS /api/v1/chat/ws`
  - bidirectional chat,
  - first server event: `type=ready`,
  - client sends JSON `{"message": "..."}`,
  - server returns `type=assistant` or `type=error`.

### 4.4 Map Services

- `GET /api/v1/map/services`
  - paginated service list,
  - filters: `provider_id`, `service_type_id`, `identifier`, `q`, `municipality`, `region`, `active_only`, etc.,
  - optional geo filters: `lat`, `lon`, `radius_km`.

- `GET /api/v1/map/services/{source_service_id}`
  - detailed service card,
  - all locations + target groups.

- `POST /api/v1/map/services/search`
  - semantic service search by `prompt` + geo radius,
  - uses prompt embedding and target-group embedding similarity.

## 5. Key Business Flows

### 5.1 Law Ingestion (JSON/PDF)

Module: `src/service/document.py`

JSON flow:

1. Decode payload.
2. Extract `metadata` + `fragmenty`.
3. Clean HTML fragments via `extract_text_from_html()`.
4. Normalize text (remove diacritics).
5. Batch and vectorize texts.
6. Persist to `lawchunk` via repository.

PDF flow:

1. Validate/decrypt PDF.
2. Extract document metadata:
   - from filename format `Sb_YYYY_NNN...`, or
   - from first pages via regex.
3. Split page text into overlapping chunks.
4. Generate embeddings.
5. Persist to `lawchunk`.

### 5.2 Semantic Search in Laws

Module: `src/service/search.py`

1. Count total/indexed chunks.
2. Convert prompt into an embedding.
3. `LawChunkRepository.find_relevant_chunks()` executes pgvector cosine distance search.
4. Return sorted `SearchResultSet`.

### 5.3 First Answer from Form

Module: `src/service/first_answer.py`

1. Convert form data into a compact retrieval query (`generated_form_prompt`).
2. Search legal sources (`SearchService`).
3. Build answer prompt from top sources.
4. Generate response through AI client.
5. Reuse the same query embedding to search relevant social services.
6. If `lat/lon` is present, apply geo-radius filtering; otherwise semantic search runs without geo filtering.

### 5.4 Chat

Module: `src/service/chat.py`

1. Build a compact search-query prompt from recent turns.
2. Run retrieval (`SearchService`).
3. Build final answer prompt from history + retrieved sources.
4. Return AI response.

## 6. Data and Database

### 6.1 Main Tables

- `lawchunk`
  - legal fragments/chunks,
  - embedding column `VECTOR(768)`.

- `socialservice`
  - service metadata (provider, type, active period).

- `servicelocation`
  - service locations (address, lat/lon).

- `servicetargetgroup`
  - target groups,
  - embedding column `VECTOR(768)`.

### 6.2 Migrations

- Alembic scripts: `migrations/versions/`
  - `84bde0775bee_initial_structure.py`
  - `ddb3cbf656ba_update_service_target_group_model.py`

The first migration enables the `vector` extension.

## 7. Configuration (ENV)

All settings are loaded from `.env` in the backend root.

### 7.1 Database

You can provide either a full URI or DSN parts:

- `POSTGRES_DATABASE_URI` (or `DATABASE_URL`, `RAILWAY_DATABASE_URL`, `POSTGRES_URL`)
- or
  - `POSTGRES_USER`
  - `POSTGRES_PASSWORD`
  - `POSTGRES_HOST`
  - `POSTGRES_PORT`
  - `POSTGRES_DB`

Additional options:

- `POSTGRES_ECHO` (default: true)
- `POSTGRES_ECHO_POOL` (default: false)
- `POSTGRES_POOL_MAX_OVERFLOW` (default: 50)
- `POSTGRES_POOL_SIZE` (default: 20)
- `POSTGRES_POOL_TIMEOUT` (default: 0)
- `POSTGRES_POOL_PRE_PING` (default: true)

### 7.2 API

- `API_HOST` (default: `0.0.0.0`)
- `API_PORT` (default: `8000`)
- `ALLOW_ORIGINS` (default: `http://localhost:3000`)
- `ALLOW_METHODS` (default: `GET,POST`)
- `ALLOW_CREDENTIALS` (default: true)
- `ALLOW_HEADERS` (default: `*`)

### 7.3 AI

- `AI_MODEL_NAME` (required)
- `AI_SERVER_URL` (required)
- `AI_REQUEST_TIMEOUT` (default: 60.0)

Note: the AI client expects an endpoint compatible with payloads like:

```json
{
  "model": "...",
  "messages": [{"role": "user", "content": "..."}],
  "stream": false
}
```

### 7.4 Embeddings

- `EMBEDDING_MODEL_NAME` (default: `sentence-transformers/paraphrase-multilingual-mpnet-base-v2`)
- `EMBEDDING_DEVICE` (optional)
- `EMBEDDING_NORMALIZE` (default: true)
- `EMBEDDING_BATCH_SIZE` (default: 100)
- `HF_TOKEN` (optional, for private/restricted model download access)

## 8. Local Run

### 8.1 Prerequisites

- Python 3.13+
- PostgreSQL with pgvector extension enabled
- `uv` installed

### 8.2 Steps

```bash
cd backend

# 1) Install dependencies
uv sync

# 2) Configure .env

# 3) Apply migrations
alembic upgrade head

# 4) Start API
python main.py
```

Swagger: `http://localhost:8000/docs`

## 9. Docker Run

Container startup uses `docker/docker-entrypoint.sh`, which runs:

1. `alembic upgrade head`
2. `python -m src.infra.embeddings.download_model`
3. `python main.py`

Build image:

```bash
cd backend
docker build -t what-now-backend .
```

Then run the container with required ENV and PostgreSQL access.

## 10. Development Commands

Migrations:

```bash
# Create a new migration
alembic revision --autogenerate -m "your message"

# Apply migrations
alembic upgrade head

# Roll back one step
alembic downgrade -1
```

## 11. Additional Utilities in the Repository

- `src/utils/geo/import_poskytovatele.py`
  - imports social services/locations/target groups from JSON/CSV,
  - generates embeddings for `servicetargetgroup.description`.

- `src/utils/geo/geolokace.py`
  - helper script for CSV preparation and address geocoding.

- `_gemma4/*`
  - standalone experimental CLI scripts for Gemma/Ollama,
  - not part of the FastAPI backend runtime path.

## 12. Important Notes

- There is no active scheduler runtime flow in the current backend code; previous mentions of daily scheduled jobs are outdated.
- `GET /api/v1/laws/` currently accepts search parameters through query args (via `Depends()`), despite the schema name `LawSearchRequest`.
- AI prompt instructions require Czech responses by default unless the user explicitly requests another language.
