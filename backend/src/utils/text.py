"""Text normalization helpers."""

import unicodedata


def remove_diacritics(text: str) -> str:
    """Return text with combining diacritic marks removed.

    Args:
        text: Input text that may contain accented characters.

    Returns:
        Text normalized to plain Latin letters where possible.
    """

    normalized_text = unicodedata.normalize("NFKD", text)
    return "".join(
        character
        for character in normalized_text
        if not unicodedata.combining(character)
    )
