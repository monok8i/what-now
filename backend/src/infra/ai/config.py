"""
Konfigurace pro AI služby (OpenAI, OpenRouter).

Tento modul definuje konfigurační třídu pro načítání API klíčů
a nastavení AI modelů z proměnných prostředí.
"""

from src.config.env import BaseEnvConfig


class Config(BaseEnvConfig):
    """
    Konfigurace pro OpenAI a OpenRouter API.

    Načítá následující proměnné prostředí z .env souboru:

    Attributes:
        OPENROUTER_API_KEY: API klíč pro OpenRouter (proxy pro různé AI modely)
                           OpenRouter umožňuje používat modely jako GPT-4, Claude,
                           Gemini atd. přes jednotné API
        OPENROUTER_AI_MODEL: Název modelu pro chat completion
                             (např. "anthropic/claude-3-opus")
        OPENAI_API_KEY: API klíč pro přímé OpenAI API
                       Používá se pro generování embeddingů (text-embedding-ada-002)

    Example v .env souboru:
        OPENROUTER_API_KEY=sk-or-v1-xxxxx
        OPENROUTER_AI_MODEL=anthropic/claude-3-opus
        OPENAI_API_KEY=sk-xxxxx
    """

    OPENROUTER_API_KEY: str
    OPENROUTER_AI_MODEL: str
    OPENAI_API_KEY: str


config = Config()  # type: ignore
