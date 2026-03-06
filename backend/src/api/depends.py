"""Dependency providers for the API."""

from src.infra.services import BenefitMatcher, QuestionnaireProcessor


def get_questionnaire_processor():
    """Dependency provider for QuestionnaireProcessor."""
    return QuestionnaireProcessor()


def get_benefit_matcher():
    """Dependency provider for BenefitMatcher."""
    return BenefitMatcher()
