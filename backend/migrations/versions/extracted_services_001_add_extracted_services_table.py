"""add extracted_services table

Revision ID: extracted_services_001
Revises: 96a77f737a88
Create Date: 2026-03-06

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "extracted_services_001"
down_revision: Union[str, None] = "96a77f737a88"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create extracted_services table."""
    op.create_table(
        "extracted_services",
        sa.Column("portal_id", sa.Integer(), nullable=False),
        sa.Column("identifier", sa.String(), nullable=False),
        sa.Column("addresses", postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column("contacts", postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column("phones", postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column("persons", postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column(
            "organizations", postgresql.JSON(astext_type=sa.Text()), nullable=False
        ),
        sa.Column("websites", postgresql.JSON(astext_type=sa.Text()), nullable=False),
        sa.Column("created_at", sa.TIMESTAMP(), nullable=False),
        sa.Column("updated_at", sa.TIMESTAMP(), nullable=False),
        sa.PrimaryKeyConstraint("portal_id"),
    )

    # Create indexes
    op.create_index(
        "ix_extracted_services_portal_id", "extracted_services", ["portal_id"]
    )
    op.create_index(
        "ix_extracted_services_identifier", "extracted_services", ["identifier"]
    )


def downgrade() -> None:
    """Drop extracted_services table."""
    op.drop_index("ix_extracted_services_identifier", table_name="extracted_services")
    op.drop_index("ix_extracted_services_portal_id", table_name="extracted_services")
    op.drop_table("extracted_services")
