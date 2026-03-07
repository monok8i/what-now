"""Dependency providers for the API."""

from src.infra.services import (
    BenefitMatcher,
    QuestionnaireProcessor,
    MapDataExtractedService,
)


def get_questionnaire_processor():
    """Dependency provider for QuestionnaireProcessor."""
    return QuestionnaireProcessor()


def get_benefit_matcher():
    """Dependency provider for BenefitMatcher."""
    return BenefitMatcher()


def get_map_data_service():
    """Dependency provider for MapDataExtractedService."""
    return MapDataExtractedService()
