"""Factories for OpenAI-compatible async clients."""

from openai import AsyncOpenAI


def get_async_openai_client(api_key: str) -> AsyncOpenAI:
    """Create an authenticated async OpenAI client.

    Args:
        api_key: Secret key used to authenticate against the OpenAI API.

    Returns:
        Configured ``AsyncOpenAI`` client instance.
    """

    return AsyncOpenAI(api_key=api_key)
