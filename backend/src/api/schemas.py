"""API schemas for data validation."""

from typing import Any

from pydantic import BaseModel, Field


class CaregiverQuestionnaireRequest(BaseModel):
    """Request model for caregiver questionnaire data."""

    # Block 1: "Kdo potřebuje péči?"
    relationship: str = Field(..., description="Vztah k pečované osobě")
    care_recipient_age: int = Field(..., description="Věk pečované osoby")
    care_recipient_gender: str = Field(..., description="Pohlaví pečované osoby")

    # Block 2: "Jak na tom je?"
    self_sufficiency: str = Field(..., description="Míra soběstačnosti")
    has_care_allowance: str = Field(..., description="Má přiznán Příspěvek na péči?")
    situation_duration: str = Field(..., description="Jak dlouho situace trvá?")

    # Block 3: "Jak to máte zařízené?"
    living_arrangement: str = Field(..., description="Kde pečovaná osoba bydlí?")
    postal_code: str = Field(..., description="PSČ bydliště pečované osoby")
    additional_help: list[str] = Field(..., description="Pomáhá ti někdo další?")

    # Block 4: "Tvoje situace"
    employment_status: str = Field(..., description="Pracuješ?")
    main_concerns: list[str] = Field(..., description="Co tě teď nejvíc trápí? (max 2)")


class CaregiverQuestionnaireResponse(BaseModel):
    """Response model for caregiver questionnaire submission."""

    message: str
    submission_id: str | None = None
    data: CaregiverQuestionnaireRequest


class SearchCriteriaResponse(BaseModel):
    """Response model showing extracted search criteria."""

    criteria: dict[str, Any]
    explanation: str


class BenefitServiceResult(BaseModel):
    """Result model for a single benefit/service."""

    id: str
    name: str
    category: str
    institution: str
    content: str
    conditions: dict[str, Any]
    next_steps: list[str] | None
    relevance_reason: str


class MatchingBenefitsResponse(BaseModel):
    """Response model for matching benefits search."""

    message: str
    submission_id: str
    total_matches: int
    search_criteria: dict[str, Any]
    matching_benefits: list[BenefitServiceResult]
    questionnaire_data: CaregiverQuestionnaireRequest
