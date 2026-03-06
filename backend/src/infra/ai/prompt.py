def create_prompt(criteria: dict[str, str], benefits: list[dict[str, str]]) -> str:
    """
    Create a formatted prompt for the AI assistant.

    Args:
        criteria: Dictionary of eligibility criteria
        benefits: List of benefit dictionaries with 'name' key

    Returns:
        Formatted prompt string
    """
    criteria_str = ", ".join([f"{k}: {v}" for k, v in criteria.items()])
    benefits_str = ", ".join([benefit["name"] for benefit in benefits])

    return f"""Jsi asistent pro lidé pečující o své blízké. Na základě těchto kritérií: {criteria_str} a těchto nalezených dávek: {benefits_str} vysvětli, proč jsou tyto dávky relevantní pro pečujícího. Uveď konkrétní kritéria, která se shodují s podmínkami"""
