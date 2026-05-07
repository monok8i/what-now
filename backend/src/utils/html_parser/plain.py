"""Minimal HTML parser that collects visible text content."""

from html.parser import HTMLParser


class PlainTextExtractor(HTMLParser):
    """Collect text nodes from HTML and return the combined plain text.

    The parser ignores markup and stores only the visible text data encountered
    during HTML parsing.
    """

    def __init__(self) -> None:
        """Initialize the internal text buffer used during parsing."""

        super().__init__()
        self._text_chunks: list[str] = []

    def handle_data(self, data: str) -> None:
        """Collect one text node from the HTML input.

        Args:
            data: Visible text extracted by the HTML parser.
        """

        self._text_chunks.append(data)

    def get_text(self) -> str:
        """Return the accumulated plain text with surrounding whitespace removed.

        Returns:
            Combined text extracted from the HTML input.
        """

        return "".join(self._text_chunks).strip()
