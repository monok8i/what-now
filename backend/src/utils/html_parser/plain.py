from html.parser import HTMLParser


class PlainTextExtractor(HTMLParser):
    """Simple HTML parser to extract plain text from HTML content."""

    def __init__(self) -> None:
        super().__init__()
        self._text_chunks: list[str] = []

    def handle_data(self, data: str) -> None:
        self._text_chunks.append(data)

    def get_text(self) -> str:
        return "".join(self._text_chunks).strip()
