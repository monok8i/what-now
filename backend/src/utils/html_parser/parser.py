"""Utility functions for parsing HTML content and extracting plain text."""

import html
from typing import Any

from src.utils.html_parser.plain import PlainTextExtractor
from src.utils.html_parser.exceptions import InvalidHTMLContentError


def extract_text_from_html(content: str | Any | None) -> str:
    """
    Extract plain text from HTML content.
    """
    if not content:
        return ""

    if not isinstance(content, str):
        raise TypeError(f"Expected str or None, got: {type(content).__name__}")

    parser = PlainTextExtractor()
    try:
        # decode HTML entities and feed to parser (e.g. &amp; -> &)
        unescaped_content = html.unescape(content)
        parser.feed(unescaped_content)
        return parser.get_text()

    except Exception as e:
        raise InvalidHTMLContentError(
            f"Error occurred while processing HTML content: {e}"
        ) from e


if __name__ == "__main__":
    sample_data: list[str | None] = [
        None,
        "",
        "<var>1.</var> V § 679 odst. 1 se slova „i o povinnostech a právech rodičů k němu“ zrušují.",
        "268",
        "<var>ČÁST PRVNÍ</var>",
        '<a data-odkaz-id="178995873" href="#" class="ext_odkaz">Zákon č. 89/2012 Sb.</a>, ve znění <a href="#">zákona č. 460/2016 Sb.</a>',
    ]

    for item in sample_data:
        clean_text = extract_text_from_html(item)
        print(f"Original: {item!r}\nCleaned:  {clean_text!r}\n{'-' * 40}")
