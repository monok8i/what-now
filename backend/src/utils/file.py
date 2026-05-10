def extract_file_type(filename: str | None) -> str:
    """Extract the file type from the given filename.

    Args:
        filename: The name of the file, including extension.
    Returns:
        The file type (extension) in lowercase, without the dot.
    """

    if filename is None or "." not in filename:
        return ""

    return filename.rsplit(".", 1)[-1].lower()
