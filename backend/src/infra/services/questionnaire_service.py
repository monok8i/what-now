"""Service for processing questionnaire data and finding matching benefits."""

from typing import Any

from sqlalchemy import Integer, cast, or_, select
from sqlalchemy.ext.asyncio import AsyncSession

from src.infra.ai.request import call_openrouter_chat
from src.infra.db.models import BenefitService


class QuestionnaireProcessor:
    """Process questionnaire data and extract search criteria."""

    # Mapping from self_sufficiency values to dependency levels
    DEPENDENCY_MAPPING = {
        "zvlada_vetsinu": 1,  # I. stupeň - lehká závislost
        "potrebuje_kazdodenne": 2,  # II. stupeň - středně těžká závislost
        "plne_zavisly": 3,  # III. stupeň - těžká závislost
        # 4 would be IV. stupeň - úplná závislost
    }

    # Mapping from main concerns to categories
    CONCERN_TO_CATEGORY = {
        "prispevky": "financni_podpora",
        "prakticka_pomoc": "pece_sluzby",
        "finance": "financni_podpora",
        "volno_z_prace": "pracovni_prava",
        "komunikace": "poradenstvi",
        "skloubeni": "poradenstvi",
    }

    @staticmethod
    def parse_questionnaire(data: dict[str, Any]) -> dict[str, Any]:
        """
        Parse questionnaire JSON and extract search criteria.

        Args:
            data: Dictionary with questionnaire data

        Returns:
            Dictionary with extracted search criteria for database matching
        """
        criteria: dict[str, Any] = {}

        # Extract age
        if "care_recipient_age" in data:
            criteria["vek"] = data["care_recipient_age"]

        # Extract gender
        if "care_recipient_gender" in data:
            criteria["pohlavi"] = data["care_recipient_gender"]

        # Convert self-sufficiency to dependency level
        if "self_sufficiency" in data:
            sufficiency = data["self_sufficiency"]
            criteria["stupen_zavislosti"] = (
                QuestionnaireProcessor.DEPENDENCY_MAPPING.get(sufficiency)
            )

        # Extract care allowance info
        if "has_care_allowance" in data:
            criteria["ma_prispevek_na_peci"] = data["has_care_allowance"]

        # Extract living arrangement
        if "living_arrangement" in data:
            criteria["living_arrangement"] = data["living_arrangement"]

        # Extract postal code (first 3 digits = region)
        if "postal_code" in data:
            postal_code = data["postal_code"].replace(" ", "")
            criteria["psc"] = postal_code
            criteria["region_kod"] = postal_code[:3]

        # Extract employment status
        if "employment_status" in data:
            criteria["status_zamestnani"] = data["employment_status"]

        # Extract categories from main concerns
        if "main_concerns" in data:
            concerns = data["main_concerns"]
            categories = [
                QuestionnaireProcessor.CONCERN_TO_CATEGORY.get(concern)
                for concern in concerns
                if concern in QuestionnaireProcessor.CONCERN_TO_CATEGORY
            ]
            criteria["kategorie_zajmu"] = list(set(categories))  # Remove duplicates
            criteria["main_concerns"] = concerns

        # Extract relationship for context
        if "relationship" in data:
            criteria["vztah"] = data["relationship"]

        return criteria

    async def generate_ai_explanation(
        self,
        criteria: dict[str, Any],
        benefits: list[dict[str, Any]],
    ) -> str:
        """Generate AI explanation for why certain benefits were matched."""

        result = await call_openrouter_chat(
            "Jsi asistent pro lidé pečující o své blízké. Na základě těchto kritérií: "
            + ", ".join([f"{k}: {v}" for k, v in criteria.items()])
            + " a těchto nalezených dávek: "
            + ", ".join([benefit["name"] for benefit in benefits])
            + " vysvětli, proč jsou tyto dávky relevantní pro pečujícího. Uveď konkrétní kritéria, která se shodují s podmínkami"
        )

        return result


class BenefitMatcher:
    """Match user criteria with benefits/services in database."""

    @staticmethod
    async def find_matching_benefits(
        db: AsyncSession, criteria: dict[str, Any]
    ) -> list[BenefitService]:
        """
        Find benefits and services matching user criteria.

        Uses PostgreSQL JSONB operators to efficiently filter records
        based on conditions stored in the database.

        Args:
            db: Async database session
            criteria: Extracted search criteria from questionnaire

        Returns:
            List of matching BenefitService records
        """
        # Start with base select statement
        stmt = select(BenefitService)

        # Age filter: user's age must be within min/max range
        if "vek" in criteria:
            age = criteria["vek"]
            stmt = stmt.where(
                or_(
                    BenefitService.conditions["vek_max"].astext.is_(None),
                    cast(BenefitService.conditions["vek_max"].astext, Integer) >= age,
                )
            )

            # Check if vek_min condition exists and user's age meets minimum
            stmt = stmt.where(
                or_(
                    BenefitService.conditions["vek_min"].astext.is_(None),
                    cast(BenefitService.conditions["vek_min"].astext, Integer) <= age,
                )
            )

        # Dependency level filter
        if "stupen_zavislosti" in criteria:
            level = criteria["stupen_zavislosti"]
            stmt = stmt.where(
                or_(
                    BenefitService.conditions["stupen_zavislosti"].astext.is_(None),
                    BenefitService.conditions["stupen_zavislosti"].astext == str(level),
                )
            )

        # Employment status filter
        if "status_zamestnani" in criteria:
            status = criteria["status_zamestnani"]
            stmt = stmt.where(
                or_(
                    BenefitService.conditions["status_zamestnani"].astext.is_(None),
                    BenefitService.conditions["status_zamestnani"].astext == status,
                )
            )

        # Category filter (if user has specific concerns)
        if "kategorie_zajmu" in criteria:
            categories = criteria["kategorie_zajmu"]
            if categories:
                stmt = stmt.where(BenefitService.category.in_(categories))

        # Execute query and fetch results
        result = await db.execute(stmt)
        return list(result.scalars().all())

    @staticmethod
    def format_results(
        benefits: list[BenefitService], criteria: dict[str, Any]
    ) -> list[dict[str, Any]]:
        """
        Format matching benefits for API response.

        Args:
            benefits: List of matching BenefitService records
            criteria: Original search criteria for context

        Returns:
            List of formatted benefit dictionaries
        """
        results: list[dict[str, Any]] = []
        for benefit in benefits:
            results.append(
                {
                    "id": benefit.id,
                    "name": benefit.name,
                    "category": benefit.category,
                    "institution": benefit.institution,
                    "content": benefit.content_text,
                    "conditions": benefit.conditions,
                    "next_steps": benefit.next_steps,
                    "relevance_reason": BenefitMatcher._generate_relevance_reason(
                        benefit, criteria
                    ),
                }
            )
        return results

    @staticmethod
    def _generate_relevance_reason(
        benefit: BenefitService, criteria: dict[str, Any]
    ) -> str:
        """Generate explanation why this benefit is relevant."""
        reasons: list[str] = []

        if "vek" in criteria and benefit.conditions.get("vek_max"):
            reasons.append(f"Věk {criteria['vek']} odpovídá věkovým podmínkám")

        if "stupen_zavislosti" in criteria and benefit.conditions.get(
            "stupen_zavislosti"
        ):
            reasons.append(
                f"Odpovídá stupni závislosti {criteria['stupen_zavislosti']}"
            )

        if not reasons:
            reasons.append("Obecně dostupná služba")

        return "; ".join(reasons)
