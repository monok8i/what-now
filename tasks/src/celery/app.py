from celery import Celery  # type: ignore

celery_app = Celery("parse-documents")

celery_app.conf.update(  # pyright: ignore[reportUnknownMemberType]
    task_serializer="json",
    result_serializer="json",
    accept_content=["json"],
    timezone="Europe/Prague",
    enable_utc=True,
)

celery_app.conf.beat_schedule = {  # pyright: ignore[reportUnknownMemberType]
    "run-parse-json-every-24-hours": {
        "task": "src.celery.parse_task.parse_json",
        "schedule": 3600 * 24,
    },
}

celery_app.conf.beat_schedule = {  # pyright: ignore[reportUnknownMemberType]
    "run-parse-pdf-every-24-hours": {
        "task": "src.celery.parse_task.parse_pdf",
        "schedule": 3600 * 24,
    },
}

celery_app.autodiscover_tasks(  # pyright: ignore[reportUnknownMemberType]
    ["src.celery"],
    related_name="parse_task",
)

# 251
