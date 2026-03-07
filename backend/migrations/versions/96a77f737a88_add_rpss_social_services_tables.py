"""add_rpss_social_services_tables

Revision ID: 96a77f737a88
Revises: 796f09ea4660
Create Date: 2026-03-06 21:31:58.435728

"""

from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision: str = "96a77f737a88"
down_revision: Union[str, Sequence[str], None] = "796f09ea4660"
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Create RPSS (Register of Social Service Providers) tables."""

    # Main social service table
    op.create_table(
        "social_service",
        sa.Column("portal_id", sa.Integer(), nullable=False),
        sa.Column("id", sa.String(length=129), nullable=False),
        sa.Column("identifikator", sa.String(length=30), nullable=False),
        sa.Column("datum_poskytovani_od", sa.Date(), nullable=False),
        sa.Column("datum_poskytovani_do", sa.Date(), nullable=True),
        sa.Column("druh_socialni_sluzby_id", sa.String(length=129), nullable=False),
        sa.PrimaryKeyConstraint("portal_id"),
    )
    op.create_index(op.f("ix_social_service_id"), "social_service", ["id"], unique=True)
    op.create_index(
        op.f("ix_social_service_identifikator"),
        "social_service",
        ["identifikator"],
        unique=False,
    )
    op.create_index(
        op.f("ix_social_service_druh_socialni_sluzby_id"),
        "social_service",
        ["druh_socialni_sluzby_id"],
        unique=False,
    )

    # Contact addresses
    op.create_table(
        "contact_address",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("adresa_text", sa.String(length=550), nullable=True),
        sa.Column("cislo_domovni", sa.Integer(), nullable=True),
        sa.Column("cislo_orientacni", sa.String(length=41), nullable=True),
        sa.Column("dodatek_adresy", sa.String(length=250), nullable=True),
        sa.Column("kod_adresniho_mista", sa.Integer(), nullable=True),
        sa.Column("psc", sa.String(length=5), nullable=True),
        sa.Column("typ_cisla_domovniho_id", sa.String(length=129), nullable=True),
        sa.Column("kraj_id", sa.String(length=129), nullable=True),
        sa.Column("okres_id", sa.String(length=129), nullable=True),
        sa.Column("obec_id", sa.String(length=129), nullable=True),
        sa.Column(
            "mestsky_obvod_mestska_cast_id", sa.String(length=129), nullable=True
        ),
        sa.Column("mestsky_obvod_v_praze_id", sa.String(length=129), nullable=True),
        sa.Column("cast_obce_id", sa.String(length=129), nullable=True),
        sa.Column("nazev_casti_obce", sa.String(length=1024), nullable=True),
        sa.Column("ulice_nazev", sa.String(length=48), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_contact_address_social_service_portal_id"),
        "contact_address",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_contact_address_kraj_id"), "contact_address", ["kraj_id"], unique=False
    )

    # Facilities
    op.create_table(
        "facility",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("nazev", sa.String(length=160), nullable=False),
        sa.Column("utajena_adresa", sa.Boolean(), nullable=False),
        sa.Column("adresa_text", sa.String(length=550), nullable=True),
        sa.Column("cislo_domovni", sa.Integer(), nullable=True),
        sa.Column("cislo_orientacni", sa.String(length=41), nullable=True),
        sa.Column("dodatek_adresy", sa.String(length=250), nullable=True),
        sa.Column("kod_adresniho_mista", sa.Integer(), nullable=True),
        sa.Column("psc", sa.String(length=5), nullable=True),
        sa.Column("typ_cisla_domovniho_id", sa.String(length=129), nullable=True),
        sa.Column("kraj_id", sa.String(length=129), nullable=True),
        sa.Column("okres_id", sa.String(length=129), nullable=True),
        sa.Column("obec_id", sa.String(length=129), nullable=True),
        sa.Column(
            "mestsky_obvod_mestska_cast_id", sa.String(length=129), nullable=True
        ),
        sa.Column("mestsky_obvod_v_praze_id", sa.String(length=129), nullable=True),
        sa.Column("cast_obce_id", sa.String(length=129), nullable=True),
        sa.Column("nazev_casti_obce", sa.String(length=1024), nullable=True),
        sa.Column("ulice_nazev", sa.String(length=48), nullable=True),
        sa.Column("poskytuje_od", sa.Date(), nullable=True),
        sa.Column("poskytuje_do", sa.Date(), nullable=True),
        sa.Column("vedouci_titul_pred", sa.String(length=35), nullable=True),
        sa.Column("vedouci_jmeno", sa.String(length=100), nullable=True),
        sa.Column("vedouci_prijmeni", sa.String(length=100), nullable=True),
        sa.Column("vedouci_titul_za", sa.String(length=30), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_facility_social_service_portal_id"),
        "facility",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(op.f("ix_facility_kraj_id"), "facility", ["kraj_id"], unique=False)

    # Provider
    op.create_table(
        "provider",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("nazev", sa.String(length=160), nullable=False),
        sa.Column("ico", sa.String(length=8), nullable=True),
        sa.Column("dic", sa.String(length=14), nullable=True),
        sa.Column("adresa_text", sa.String(length=550), nullable=True),
        sa.Column("cislo_domovni", sa.Integer(), nullable=True),
        sa.Column("cislo_orientacni", sa.String(length=41), nullable=True),
        sa.Column("dodatek_adresy", sa.String(length=250), nullable=True),
        sa.Column("kod_adresniho_mista", sa.Integer(), nullable=True),
        sa.Column("psc", sa.String(length=5), nullable=True),
        sa.Column("typ_cisla_domovniho_id", sa.String(length=129), nullable=True),
        sa.Column("kraj_id", sa.String(length=129), nullable=True),
        sa.Column("okres_id", sa.String(length=129), nullable=True),
        sa.Column("obec_id", sa.String(length=129), nullable=True),
        sa.Column(
            "mestsky_obvod_mestska_cast_id", sa.String(length=129), nullable=True
        ),
        sa.Column("mestsky_obvod_v_praze_id", sa.String(length=129), nullable=True),
        sa.Column("cast_obce_id", sa.String(length=129), nullable=True),
        sa.Column("nazev_casti_obce", sa.String(length=1024), nullable=True),
        sa.Column("ulice_nazev", sa.String(length=48), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_provider_social_service_portal_id"),
        "provider",
        ["social_service_portal_id"],
        unique=True,
    )
    op.create_index(op.f("ix_provider_ico"), "provider", ["ico"], unique=False)
    op.create_index(op.f("ix_provider_kraj_id"), "provider", ["kraj_id"], unique=False)

    # Statutory bodies
    op.create_table(
        "statutory_body",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("provider_id", sa.Integer(), nullable=False),
        sa.Column("funkce_id", sa.String(length=129), nullable=False),
        sa.Column("popis_funkce", sa.String(length=250), nullable=True),
        sa.Column("titul_pred", sa.String(length=35), nullable=True),
        sa.Column("jmeno", sa.String(length=100), nullable=False),
        sa.Column("prijmeni", sa.String(length=100), nullable=False),
        sa.Column("titul_za", sa.String(length=30), nullable=True),
        sa.ForeignKeyConstraint(
            ["provider_id"],
            ["provider.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_statutory_body_provider_id"),
        "statutory_body",
        ["provider_id"],
        unique=False,
    )

    # Service contact information
    op.create_table(
        "service_email",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("email", sa.String(length=254), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_email_social_service_portal_id"),
        "service_email",
        ["social_service_portal_id"],
        unique=False,
    )

    op.create_table(
        "service_phone",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("telefon", sa.String(length=50), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_phone_social_service_portal_id"),
        "service_phone",
        ["social_service_portal_id"],
        unique=False,
    )

    op.create_table(
        "service_fax",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("fax", sa.String(length=50), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_fax_social_service_portal_id"),
        "service_fax",
        ["social_service_portal_id"],
        unique=False,
    )

    op.create_table(
        "service_web",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("web", sa.String(length=2048), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_web_social_service_portal_id"),
        "service_web",
        ["social_service_portal_id"],
        unique=False,
    )

    # Provider contact information
    op.create_table(
        "provider_email",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("provider_id", sa.Integer(), nullable=False),
        sa.Column("email", sa.String(length=254), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["provider_id"],
            ["provider.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_provider_email_provider_id"),
        "provider_email",
        ["provider_id"],
        unique=False,
    )

    op.create_table(
        "provider_phone",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("provider_id", sa.Integer(), nullable=False),
        sa.Column("telefon", sa.String(length=50), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["provider_id"],
            ["provider.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_provider_phone_provider_id"),
        "provider_phone",
        ["provider_id"],
        unique=False,
    )

    op.create_table(
        "provider_fax",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("provider_id", sa.Integer(), nullable=False),
        sa.Column("fax", sa.String(length=50), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["provider_id"],
            ["provider.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_provider_fax_provider_id"),
        "provider_fax",
        ["provider_id"],
        unique=False,
    )

    op.create_table(
        "provider_web",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("provider_id", sa.Integer(), nullable=False),
        sa.Column("web", sa.String(length=2048), nullable=False),
        sa.Column("poznamka", sa.String(length=512), nullable=True),
        sa.ForeignKeyConstraint(
            ["provider_id"],
            ["provider.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_provider_web_provider_id"),
        "provider_web",
        ["provider_id"],
        unique=False,
    )

    # Target groups and age groups
    op.create_table(
        "service_target_group",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("cilova_skupina_id", sa.String(length=129), nullable=False),
        sa.Column("doplnujici_informace", sa.Text(), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_target_group_social_service_portal_id"),
        "service_target_group",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_service_target_group_cilova_skupina_id"),
        "service_target_group",
        ["cilova_skupina_id"],
        unique=False,
    )

    op.create_table(
        "service_age_group",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("vekova_skupina_id", sa.String(length=129), nullable=False),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_age_group_social_service_portal_id"),
        "service_age_group",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_service_age_group_vekova_skupina_id"),
        "service_age_group",
        ["vekova_skupina_id"],
        unique=False,
    )

    op.create_table(
        "age_group_additional_info",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("popis", sa.String(length=4000), nullable=True),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_age_group_additional_info_social_service_portal_id"),
        "age_group_additional_info",
        ["social_service_portal_id"],
        unique=False,
    )

    # Service forms
    op.create_table(
        "service_form",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("forma_id", sa.String(length=129), nullable=False),
        sa.Column("nepretrzite_poskytovani", sa.Boolean(), nullable=False),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_form_social_service_portal_id"),
        "service_form",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_service_form_forma_id"), "service_form", ["forma_id"], unique=False
    )

    # Time ranges
    op.create_table(
        "time_range",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("service_form_id", sa.Integer(), nullable=False),
        sa.Column("den_id", sa.String(length=129), nullable=False),
        sa.Column("interval", sa.String(length=4000), nullable=False),
        sa.ForeignKeyConstraint(
            ["service_form_id"],
            ["service_form.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_time_range_service_form_id"),
        "time_range",
        ["service_form_id"],
        unique=False,
    )

    # Service capacities
    op.create_table(
        "service_capacity",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("service_form_id", sa.Integer(), nullable=False),
        sa.Column("typ_id", sa.String(length=129), nullable=False),
        sa.Column("pocet", sa.Integer(), nullable=False),
        sa.Column("popis", sa.String(length=4000), nullable=True),
        sa.ForeignKeyConstraint(
            ["service_form_id"],
            ["service_form.id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_service_capacity_service_form_id"),
        "service_capacity",
        ["service_form_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_service_capacity_typ_id"), "service_capacity", ["typ_id"], unique=False
    )

    # Extended regional scope
    op.create_table(
        "extended_regional_scope",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column("kraj_id", sa.String(length=129), nullable=False),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_extended_regional_scope_social_service_portal_id"),
        "extended_regional_scope",
        ["social_service_portal_id"],
        unique=False,
    )
    op.create_index(
        op.f("ix_extended_regional_scope_kraj_id"),
        "extended_regional_scope",
        ["kraj_id"],
        unique=False,
    )

    # Additional data
    op.create_table(
        "additional_data",
        sa.Column("id", sa.Integer(), autoincrement=True, nullable=False),
        sa.Column("social_service_portal_id", sa.Integer(), nullable=False),
        sa.Column(
            "personalni_zajisteni",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=True,
        ),
        sa.Column(
            "realizace_poskytovani",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=True,
        ),
        sa.Column(
            "kontroly_plneni_registracnich_podminek",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=True,
        ),
        sa.Column(
            "plany_financniho_zajisteni",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=True,
        ),
        sa.Column(
            "dotace_ze_statniho_rozpoctu",
            postgresql.JSONB(astext_type=sa.Text()),
            nullable=True,
        ),
        sa.Column(
            "evidovane_inspekce", postgresql.JSONB(astext_type=sa.Text()), nullable=True
        ),
        sa.ForeignKeyConstraint(
            ["social_service_portal_id"],
            ["social_service.portal_id"],
        ),
        sa.PrimaryKeyConstraint("id"),
    )
    op.create_index(
        op.f("ix_additional_data_social_service_portal_id"),
        "additional_data",
        ["social_service_portal_id"],
        unique=True,
    )


def downgrade() -> None:
    """Drop RPSS tables."""
    op.drop_index(
        op.f("ix_additional_data_social_service_portal_id"),
        table_name="additional_data",
    )
    op.drop_table("additional_data")

    op.drop_index(
        op.f("ix_extended_regional_scope_kraj_id"), table_name="extended_regional_scope"
    )
    op.drop_index(
        op.f("ix_extended_regional_scope_social_service_portal_id"),
        table_name="extended_regional_scope",
    )
    op.drop_table("extended_regional_scope")

    op.drop_index(op.f("ix_service_capacity_typ_id"), table_name="service_capacity")
    op.drop_index(
        op.f("ix_service_capacity_service_form_id"), table_name="service_capacity"
    )
    op.drop_table("service_capacity")

    op.drop_index(op.f("ix_time_range_service_form_id"), table_name="time_range")
    op.drop_table("time_range")

    op.drop_index(op.f("ix_service_form_forma_id"), table_name="service_form")
    op.drop_index(
        op.f("ix_service_form_social_service_portal_id"), table_name="service_form"
    )
    op.drop_table("service_form")

    op.drop_index(
        op.f("ix_age_group_additional_info_social_service_portal_id"),
        table_name="age_group_additional_info",
    )
    op.drop_table("age_group_additional_info")

    op.drop_index(
        op.f("ix_service_age_group_vekova_skupina_id"), table_name="service_age_group"
    )
    op.drop_index(
        op.f("ix_service_age_group_social_service_portal_id"),
        table_name="service_age_group",
    )
    op.drop_table("service_age_group")

    op.drop_index(
        op.f("ix_service_target_group_cilova_skupina_id"),
        table_name="service_target_group",
    )
    op.drop_index(
        op.f("ix_service_target_group_social_service_portal_id"),
        table_name="service_target_group",
    )
    op.drop_table("service_target_group")

    op.drop_index(op.f("ix_provider_web_provider_id"), table_name="provider_web")
    op.drop_table("provider_web")

    op.drop_index(op.f("ix_provider_fax_provider_id"), table_name="provider_fax")
    op.drop_table("provider_fax")

    op.drop_index(op.f("ix_provider_phone_provider_id"), table_name="provider_phone")
    op.drop_table("provider_phone")

    op.drop_index(op.f("ix_provider_email_provider_id"), table_name="provider_email")
    op.drop_table("provider_email")

    op.drop_index(
        op.f("ix_service_web_social_service_portal_id"), table_name="service_web"
    )
    op.drop_table("service_web")

    op.drop_index(
        op.f("ix_service_fax_social_service_portal_id"), table_name="service_fax"
    )
    op.drop_table("service_fax")

    op.drop_index(
        op.f("ix_service_phone_social_service_portal_id"), table_name="service_phone"
    )
    op.drop_table("service_phone")

    op.drop_index(
        op.f("ix_service_email_social_service_portal_id"), table_name="service_email"
    )
    op.drop_table("service_email")

    op.drop_index(op.f("ix_statutory_body_provider_id"), table_name="statutory_body")
    op.drop_table("statutory_body")

    op.drop_index(op.f("ix_provider_kraj_id"), table_name="provider")
    op.drop_index(op.f("ix_provider_ico"), table_name="provider")
    op.drop_index(op.f("ix_provider_social_service_portal_id"), table_name="provider")
    op.drop_table("provider")

    op.drop_index(op.f("ix_facility_kraj_id"), table_name="facility")
    op.drop_index(op.f("ix_facility_social_service_portal_id"), table_name="facility")
    op.drop_table("facility")

    op.drop_index(op.f("ix_contact_address_kraj_id"), table_name="contact_address")
    op.drop_index(
        op.f("ix_contact_address_social_service_portal_id"),
        table_name="contact_address",
    )
    op.drop_table("contact_address")

    op.drop_index(
        op.f("ix_social_service_druh_socialni_sluzby_id"), table_name="social_service"
    )
    op.drop_index(op.f("ix_social_service_identifikator"), table_name="social_service")
    op.drop_index(op.f("ix_social_service_id"), table_name="social_service")
    op.drop_table("social_service")
