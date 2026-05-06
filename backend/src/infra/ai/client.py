"""
Klient pro komunikaci s OpenAI/OpenRouter API.

Tento modul poskytuje inicializované instance klientů pro:
- OpenAI API (chat completion, embeddings)
- OpenRouter API (proxy pro různé AI modely)

Klíče jsou načítány z globální konfigurace.
"""

from openai import AsyncOpenAI


def get_async_openai_client(api_key: str) -> AsyncOpenAI:
    return AsyncOpenAI(api_key=api_key)
