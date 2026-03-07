"""
Module for calling OpenRouter API for chat completion.

This module provides a function for asynchronous communication with OpenRouter API,
which serves as a proxy for various AI models (GPT-4, Claude, Gemini, etc.).
Supports conversation history and system prompts.
"""

import httpx

from .config import config as ai_config


async def call_openrouter_chat(
    user_message: str,
    additional_context: str | None = None,
    model_override: str | None = None,
    conversation_history: list[dict[str, str]] | None = None,
    system_prompt: str | None = None,
    max_tokens: int = 4096,
) -> str:
    """
    Calls OpenRouter API with support for conversation history.

    OpenRouter is a proxy service that allows using various AI models
    (OpenAI GPT, Anthropic Claude, Google Gemini, etc.) through a unified API.
    This function supports:
    - Different AI models (default or override)
    - Conversation memory (message history)
    - System prompts for behavior definition
    - Asynchronous calling for better performance

    Args:
        user_message: Current message from user or prompt for AI
        model_override: Optionally override default model from config
                       E.g. "google/gemini-2.5-flash-lite-preview-09-2025"
                       for fast and cheap queries
        conversation_history: List of previous messages in format:
                             [{"role": "user", "content": "..."},
                              {"role": "assistant", "content": "..."}]
                             Allows AI to respond in context of entire conversation
        system_prompt: Optional system prompt defining AI behavior
                      E.g. "You are an expert assistant for legal documents..."
        max_tokens: Maximum number of tokens in response (default: 4096)
                   Higher value = longer responses, but higher cost

    Returns:
        str: Text response from AI model

    Raises:
        Does not raise exceptions, returns error messages as string for robustness

    Example:
        >>> # Simple query without history
        >>> answer = await call_openrouter_chat("What is Python?")
        >>>
        >>> # Query with conversation history
        >>> history = [
        ...     {"role": "user", "content": "What's your name?"},
        ...     {"role": "assistant", "content": "I'm an AI assistant."}
        ... ]
        >>> answer = await call_openrouter_chat(
        ...     "And what can you do?",
        ...     conversation_history=history
        ... )
        >>>
        >>> # Using fast model for optimization
        >>> query = await call_openrouter_chat(
        ...     "Rephrase: where can I find building permit?",
        ...     model_override="google/gemini-2.5-flash-lite-preview-09-2025",
        ...     max_tokens=128
        ... )
    """
    # Load configuration
    api_key = ai_config.OPENROUTER_API_KEY

    # Use default or override model
    model = model_override if model_override else ai_config.OPENROUTER_AI_MODEL

    # OpenRouter endpoint
    base_url = "https://openrouter.ai/api/v1"
    url = f"{base_url}/chat/completions"

    # HTTP headers for authorization
    headers = {
        "Authorization": f"Bearer {api_key}",
        "Content-Type": "application/json",
    }

    # Assemble messages in OpenAI format
    messages: list[dict[str, str]] = []

    # 1. Add system prompt if provided
    # System prompt defines AI behavior and has highest priority
    if system_prompt:
        messages.append({"role": "system", "content": system_prompt})

    # 2. Add conversation history if exists
    # History allows AI to understand context and build on previous messages
    if conversation_history:
        messages.extend(conversation_history)

    # 3. Add current user message
    # This is the query that AI should respond to
    messages.append({"role": "user", "content": user_message})

    # 4. Add additional context if provided
    # This can include any extra information that might be helpful for the AI
    if additional_context:
        messages.append({"role": "user", "content": additional_context})

    # Payload pro OpenRouter API
    payload = {  # type: ignore
        "model": model,
        "messages": messages,
        "max_tokens": max_tokens,
    }

    try:
        # Asynchronous HTTP request with 60s timeout
        async with httpx.AsyncClient(timeout=60) as client:
            resp = await client.post(url, headers=headers, json=payload)  # type: ignore
            resp.raise_for_status()  # Raises exception on HTTP error
            data = resp.json()

            # Parse response
            # Expected format: { choices: [ { message: { content: "..." } } ] }
            choices = data.get("choices", [])
            if not choices:
                return "OpenRouter: no choices returned."

            message = choices[0].get("message", {})
            content = message.get("content")

            # Content can be string or list of parts
            if isinstance(content, str):
                return content

            # Some providers return content as list of objects
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
        # HTTP error (4xx, 5xx)
        try:
            err = e.response.json()
        except Exception:
            err = {"detail": e.response.text}
        return f"OpenRouter HTTP {e.response.status_code}: {err}"

    except Exception as e:
        # Jiná chyba (timeout, connection error, atd.)
        return f"Error calling OpenRouter: {e}"
