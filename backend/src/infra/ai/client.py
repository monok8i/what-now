"""
Klient pro komunikaci s OpenAI/OpenRouter API.

Tento modul poskytuje inicializované instance klientů pro:
- OpenAI API (chat completion, embeddings)
- OpenRouter API (proxy pro různé AI modely)

Klíče jsou načítány z globální konfigurace.
"""

from openai import OpenAI

from .config import config as ai_config

# Globální instance OpenAI klienta
# Používá se pro generování embeddingů (vektorových reprezentací textu)
openai = OpenAI(api_key=ai_config.OPENAI_API_KEY)


def get_openai_client() -> OpenAI:
    """
    Vrací instanci OpenAI klienta.

    Tento klient se používá především pro generování textových embeddingů,
    které jsou ukládány do vektorové databáze. Embeddingy umožňují
    sémantické vyhledávání - nalezení podobných dokumentů podle významu,
    ne pouze podle klíčových slov.

    Returns:
        OpenAI: Nakonfigurovaný OpenAI klient s API klíčem

    Example:
        >>> client = get_openai_client()
        >>> response = client.embeddings.create(...)
    """
    return openai
