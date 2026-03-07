"""API schemas for data validation."""

from typing import Any

from pydantic import BaseModel, ConfigDict, Field


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
    ai_response: str | None = None


class ExtractedServiceResponse(BaseModel):
    """Response model for extracted service data from RPSS portal."""

    model_config = ConfigDict(from_attributes=True)

    portal_id: int = Field(..., description="Unique portal ID")
    identifier: str = Field(..., description="Service identifier")
    addresses: list[dict[str, Any]] = Field(  # type: ignore
        default_factory=list,
        description="List of addresses (psc, city_id, street, house_number, orientation_number)",
    )
    contacts: list[str] = Field(default_factory=list, description="Email contacts")
    phones: list[str] = Field(default_factory=list, description="Phone numbers")
    persons: list[dict[str, Any]] = Field(  # type: ignore
        default_factory=list,
        description="List of persons (first_name, last_name, title_before, title_after, function_period)",
    )
    organizations: list[str] = Field(
        default_factory=list, description="Organization names"
    )
    websites: list[str] = Field(default_factory=list, description="Website URLs")
