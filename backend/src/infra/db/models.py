"""SQLAlchemy models for benefits and services database."""

from typing import Any

from sqlalchemy import JSON, String, Text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import Mapped, mapped_column

from src.infra.db.base import Base


class BenefitService(Base):
    """
    Model for storing social benefits and services information.

    This table stores paragraphs/information about various social benefits,
    allowances, and services with their matching conditions in JSONB format.
    """

    id: Mapped[str] = mapped_column(String, primary_key=True)
    """Unique identifier for the benefit/service"""

    category: Mapped[str] = mapped_column(String, nullable=False, index=True)
    """Category of the benefit (e.g., 'prispevek_na_peci', 'nemocenske_pojisteni')"""

    institution: Mapped[str] = mapped_column(String, nullable=False)
    """Institution responsible (e.g., 'Úřad práce ČR', 'ČSSZ')"""

    name: Mapped[str] = mapped_column(String, nullable=False)
    """Name/title of the benefit or service"""

    content_text: Mapped[str] = mapped_column(Text, nullable=False)
    """Full text content describing the benefit/service"""

    conditions: Mapped[dict[str, Any]] = mapped_column(JSONB, nullable=False)
    """
    JSONB object containing matching conditions.

    Example structure:
    {
        "vek_max": 17,                    # Maximum age
        "vek_min": 0,                     # Minimum age
        "stupen_zavislosti": 3,           # Level of dependency (1-4)
        "typ_zavislosti": "těžká",        # Type of dependency
        "nezvladnute_potreby_min": 6,     # Min unmanaged needs
        "status_zamestnani": "zamestnanec", # Employment status
        "delka_hospitalizace_min": 4,     # Min hospitalization days
        "region": "Praha",                # Region/city
        "prukazy_ozp": ["ZTP", "ZTP/P"],  # Disability cards
        "living_arrangement": "u_me_doma" # Living arrangement
    }
    """

    source_id: Mapped[str | None] = mapped_column(String, nullable=True)
    """Reference to source document"""

    next_steps: Mapped[list[str] | None] = mapped_column(JSON, nullable=True)
    """JSON array of next step IDs or processes"""

    def __repr__(self) -> str:
        return f"<BenefitService(id='{self.id}', name='{self.name}')>"
