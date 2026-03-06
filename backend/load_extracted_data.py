#!/usr/bin/env python3
"""
Скрипт для загрузки данных из output_fixed.json в базу данных.
"""

import asyncio
import json
import sys
from pathlib import Path

from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy import select

# Добавляем путь к backend в sys.path
backend_dir = Path(__file__).parent
sys.path.insert(0, str(backend_dir))

from src.infra.db.config import config as db_config  # noqa: E402
from src.infra.db.models import ExtractedService  # noqa: E402


async def load_data_from_json(json_file_path: str, db_url: str) -> None:
    """
    Загружает данные из JSON файла в базу данных.

    Args:
        json_file_path: Путь к JSON файлу с данными
        db_url: URL подключения к базе данных
    """
    print(f"Загрузка данных из: {json_file_path}")

    # Читаем JSON файл
    with open(json_file_path, "r", encoding="utf-8") as f:
        data = json.load(f)

    records = data.get("records", [])
    total = len(records)
    print(f"Найдено {total} записей\n")

    # Создаем engine и session
    engine = create_async_engine(db_url, echo=False)
    async_session = async_sessionmaker(
        engine, class_=AsyncSession, expire_on_commit=False
    )

    # Загружаем данные
    async with async_session() as session:
        added = 0
        updated = 0
        errors = 0

        for i, record in enumerate(records, 1):
            try:
                portal_id = record.get("portal_id")
                if not portal_id:
                    print(f"⚠️  Запись {i}: нет portal_id, пропускаем")
                    errors += 1
                    continue

                # Проверяем существует ли уже
                stmt = select(ExtractedService).where(
                    ExtractedService.portal_id == portal_id
                )
                result = await session.execute(stmt)
                existing = result.scalar_one_or_none()

                if existing:
                    # Обновляем существующую запись
                    existing.identifier = record.get("identifier", "")
                    existing.addresses = record.get("addresses", [])
                    existing.contacts = record.get("contacts", [])
                    existing.phones = record.get("phones", [])
                    existing.persons = record.get("persons", [])
                    existing.organizations = record.get("organizations", [])
                    existing.websites = record.get("websites", [])
                    updated += 1
                else:
                    # Создаем новую запись
                    service = ExtractedService(
                        portal_id=portal_id,
                        identifier=record.get("identifier", ""),
                        addresses=record.get("addresses", []),
                        contacts=record.get("contacts", []),
                        phones=record.get("phones", []),
                        persons=record.get("persons", []),
                        organizations=record.get("organizations", []),
                        websites=record.get("websites", []),
                    )
                    session.add(service)
                    added += 1

                # Коммитим каждые 100 записей
                if i % 100 == 0:
                    await session.commit()
                    print(
                        f"Обработано: {i}/{total} (добавлено: {added}, обновлено: {updated}, ошибок: {errors})"
                    )

            except Exception as e:
                print(
                    f"❌ Ошибка при обработке записи {i} (portal_id={record.get('portal_id')}): {e}"
                )
                errors += 1
                await session.rollback()

        # Финальный коммит
        await session.commit()

    print("\n✅ Загрузка завершена!")
    print(f"   Добавлено новых: {added}")
    print(f"   Обновлено: {updated}")
    print(f"   Ошибок: {errors}")
    print(f"   Всего обработано: {total}")

    await engine.dispose()


async def example_queries(db_url: str) -> None:
    """
    Примеры запросов к загруженным данным.
    """
    engine = create_async_engine(db_url, echo=False)
    async_session = async_sessionmaker(engine, class_=AsyncSession)

    async with async_session() as session:
        # Общее количество
        stmt = select(ExtractedService)
        result = await session.execute(stmt)
        services = result.scalars().all()

        print("\n=== Примеры запросов ===")
        print(f"Всего записей в БД: {len(services)}\n")

        # Первые 3 записи
        print("Первые 3 записи:")
        for service in services[:3]:
            print(f"  - ID: {service.portal_id}, Identifier: {service.identifier}")
            print(
                f"    Адресов: {len(service.addresses)}, Контактов: {len(service.contacts)}"
            )
            print(
                f"    Телефонов: {len(service.phones)}, Организаций: {len(service.organizations)}"
            )

        # Записи с email контактами
        stmt = select(ExtractedService).where(ExtractedService.contacts != []).limit(5)
        result = await session.execute(stmt)
        services_with_contacts = result.scalars().all()

        print("\nЗаписи с email контактами (первые 5):")
        for service in services_with_contacts:
            print(
                f"  - ID: {service.portal_id}, Email: {', '.join(service.contacts[:2])}"
            )

    await engine.dispose()


def main():
    """
    Главная функция.
    """
    # Параметры по умолчанию
    json_file = str(Path(__file__).parent / "output_fixed.json")
    db_url = db_config.POSTGRES_DATABASE_URI

    if len(sys.argv) > 1:
        json_file = sys.argv[1]
    if len(sys.argv) > 2:
        db_url = sys.argv[2]

    print("=" * 60)
    print("Загрузка данных RPSS в базу данных")
    print("=" * 60)
    print(f"JSON файл: {json_file}")
    print(f"База данных: {db_url}")
    print("=" * 60 + "\n")

    try:
        # Загружаем данные
        asyncio.run(load_data_from_json(json_file, db_url))  # type: ignore

        # Показываем примеры
        asyncio.run(example_queries(db_url))  # type: ignore

    except FileNotFoundError:
        print(f"❌ Ошибка: файл {json_file} не найден")
        sys.exit(1)
    except Exception as e:
        print(f"❌ Ошибка: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
