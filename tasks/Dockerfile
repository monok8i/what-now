### ───────────────────────────────────────────────
### Builder stage
### ───────────────────────────────────────────────
FROM ghcr.io/astral-sh/uv:python3.13-bookworm AS builder

ENV UV_COMPILE_BYTECODE=1 UV_LINK_MODE=copy
ENV UV_PYTHON_DOWNLOADS=0

WORKDIR /app

COPY pyproject.toml uv.lock ./

RUN apt-get update \
    && apt-get install -y --no-install-recommends git bash build-essential \
    && rm -rf /var/lib/apt/lists/*


RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-install-project --no-dev

COPY . /app

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --locked --no-dev

RUN rm -f pyproject.toml uv.lock .python-version \
    && rm -rf /app/.cache

### ───────────────────────────────────────────────
### Runtime stage
### ───────────────────────────────────────────────
FROM python:3.13-slim-bookworm AS runtime

WORKDIR /app

COPY --from=builder /app /app

ENV PATH="/app/.venv/bin:$PATH"

EXPOSE 8001

RUN apt-get update \
    && python -m playwright install --with-deps chromium \
    && rm -rf /var/lib/apt/lists/*

RUN rm -rf /app/.venv/share/man \
    /app/.venv/lib/python*/test \
    /app/.venv/lib/python*/ensurepip \
    /app/.venv/lib/python*/distutils/tests \
    /app/.venv/lib/python*/tkinter