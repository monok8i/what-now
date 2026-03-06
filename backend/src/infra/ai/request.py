"""
Modul pro volání OpenRouter API pro chat completion.

Tento modul poskytuje funkci pro asynchronní komunikaci s OpenRouter API,
které slouží jako proxy pro různé AI modely (GPT-4, Claude, Gemini, atd.).
Podporuje konverzační historii a system prompts.
"""

import httpx

from .config import config as ai_config


async def call_openrouter_chat(
    user_message: str,
    model_override: str | None = None,
    conversation_history: list[dict[str, str]] | None = None,
    system_prompt: str | None = None,
    max_tokens: int = 4096,
) -> str:
    """
    Volá OpenRouter API s podporou pro konverzační historii.

    OpenRouter je proxy služba, která umožňuje používat různé AI modely
    (OpenAI GPT, Anthropic Claude, Google Gemini, atd.) přes jednotné API.
    Tato funkce podporuje:
    - Různé AI modely (výchozí nebo override)
    - Konverzační paměť (historie zpráv)
    - System prompty pro definici chování
    - Asynchronní volání pro lepší výkon

    Args:
        user_message: Aktuální zpráva od uživatele nebo prompt pro AI
        model_override: Volitelně přepsat výchozí model z konfigurace
                       Např. "google/gemini-2.5-flash-lite-preview-09-2025"
                       pro rychlé a levné dotazy
        conversation_history: Seznam předchozích zpráv ve formátu:
                             [{"role": "user", "content": "..."},
                              {"role": "assistant", "content": "..."}]
                             Umožňuje AI reagovat v kontextu celé konverzace
        system_prompt: Volitelný systémový prompt definující chování AI
                      Např. "Jsi odborný asistent pro právní dokumenty..."
        max_tokens: Maximální počet tokenů v odpovědi (default: 4096)
                   Vyšší hodnota = delší odpovědi, ale vyšší cena

    Returns:
        str: Textová odpověď od AI modelu

    Raises:
        Nevrací exception, ale chybové hlášky jako string pro robustnost

    Example:
        >>> # Jednoduchý dotaz bez historie
        >>> odpoved = await call_openrouter_chat("Co je to Python?")
        >>>
        >>> # Dotaz s historií konverzace
        >>> historie = [
        ...     {"role": "user", "content": "Jak se jmenuješ?"},
        ...     {"role": "assistant", "content": "Jsem AI asistent."}
        ... ]
        >>> odpoved = await call_openrouter_chat(
        ...     "A co umíš?",
        ...     conversation_history=historie
        ... )
        >>>
        >>> # Použití rychlého modelu pro optimalizaci
        >>> query = await call_openrouter_chat(
        ...     "Přeformuluj: kde najdu stavební povolení?",
        ...     model_override="google/gemini-2.5-flash-lite-preview-09-2025",
        ...     max_tokens=128
        ... )
    """
    # Načtení konfigurace
    api_key = ai_config.OPENROUTER_API_KEY

    # Použití výchozího nebo override modelu
    model = model_override if model_override else ai_config.OPENROUTER_AI_MODEL

    # OpenRouter endpoint
    base_url = "https://openrouter.ai/api/v1"
    url = f"{base_url}/chat/completions"

    # HTTP hlavičky pro autorizaci
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    # Sestavení zpráv v OpenAI formátu
    messages: list[dict[str, str]] = []

    # 1. Přidat systémový prompt, pokud je zadán
    # System prompt definuje chování AI a má nejvyšší prioritu
    if system_prompt:
        messages.append({"role": "system", "content": system_prompt})

    # 2. Přidat historii konverzace, pokud existuje
    # Historie umožňuje AI rozumět kontextu a navazovat na předchozí zprávy
    if conversation_history:
        messages.extend(conversation_history)

    # 3. Přidat aktuální zprávu uživatele
    # Toto je dotaz, na který má AI odpovědět
    messages.append({"role": "user", "content": user_message})

    # Payload pro OpenRouter API
    payload = {  # type: ignore
        "model": model,
        "messages": messages,
        "max_tokens": max_tokens,
    }

    try:
        # Asynchronní HTTP požadavek s timeoutem 60s
        async with httpx.AsyncClient(timeout=60) as client:
            resp = await client.post(url, headers=headers, json=payload)  # type: ignore
            resp.raise_for_status()  # Vyvolá exception při HTTP chybě
            data = resp.json()

            # Parsování odpovědi
            # Očekávaný formát: { choices: [ { message: { content: "..." } } ] }
            choices = data.get("choices", [])
            if not choices:
                return "OpenRouter: no choices returned."

            message = choices[0].get("message", {})
            content = message.get("content")

            # Content může být string nebo list částí
            if isinstance(content, str):
                return content

            # Některé providery vrací content jako list objektů
            if isinstance(content, list):
                parts = []
                for part in content:  # type: ignore
                    if isinstance(part, dict) and part.get("type") == "text":  # type: ignore
                        parts.append(part.get("text", ""))  # type: ignore
                    elif isinstance(part, str):
                        parts.append(part)  # type: ignore
                if parts:
                    return "".join(parts)  # type: ignore

            return "OpenRouter: unexpected response content format."

    except httpx.HTTPStatusError as e:
        # HTTP chyba (4xx, 5xx)
        try:
            err = e.response.json()
        except Exception:
            err = {"detail": e.response.text}
        return f"OpenRouter HTTP {e.response.status_code}: {err}"

    except Exception as e:
        # Jiná chyba (timeout, connection error, atd.)
        return f"Error calling OpenRouter: {e}"
