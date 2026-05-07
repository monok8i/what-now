import asyncio
from src.celery.app import celery_app
from src.service import ParseDocsService

parse_service = ParseDocsService()


@celery_app.task  # type: ignore
def run_due_json():
    asyncio.run(parse_service.parse_json())


@celery_app.task  # type: ignore
def run_due_pdf():
    asyncio.run(parse_service.parse_pdf())
