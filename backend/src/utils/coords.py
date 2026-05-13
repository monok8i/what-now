"""Coordinate and CSV value parsing helpers."""

from __future__ import annotations

from decimal import Decimal, InvalidOperation


def normalize_optional_text(value: str | None) -> str | None:
    """Normalize blank CSV fields to ``None``.

    Args:
            value: Raw text value read from a CSV cell.

    Returns:
            Stripped text or ``None`` when the value is empty or a textual null.
    """

    if value is None:
        return None

    normalized_value = value.strip()
    if not normalized_value or normalized_value.lower() == "none":
        return None

    return normalized_value


def parse_optional_decimal(value: str | None) -> Decimal | None:
    """Convert a CSV cell into ``Decimal`` when a value is present.

    Args:
            value: Raw numeric text from the CSV.

    Returns:
            Parsed decimal value, or ``None`` when the cell is empty.

    Raises:
            ValueError: If the text cannot be converted to ``Decimal``.
    """

    normalized_value = normalize_optional_text(value)
    if normalized_value is None:
        return None

    try:
        return Decimal(normalized_value)
    except InvalidOperation as exc:
        raise ValueError(f"Invalid decimal value: {value!r}") from exc
