#!/usr/bin/env python3
"""
Скрипт для извлечения только необходимых полей из RPSS JSON файла.
Извлекает: адрес (psc, город, улица, номер дома), контакты, телефоны, имена людей, названия организаций, веб-сайты
"""

import json
import sys
from typing import Any, Dict, List, Set


def extract_from_nested(obj: Any, key: str, results: Set[Any]) -> None:
    """
    Рекурсивно находит все значения по ключу в любой вложенности.
    """
    if isinstance(obj, dict):
        if key in obj and obj[key] is not None:
            value: Any = obj[key]  # type: ignore[misc]
            # Если значение - объект с id, берем id или nazev
            if isinstance(value, dict):
                if "id" in value:
                    results.add(value["id"])
                elif "nazev" in value:
                    results.add(value["nazev"])
                else:
                    # Преобразуем весь объект в строку
                    results.add(json.dumps(value, ensure_ascii=False))
            else:
                results.add(str(value))  # type: ignore[arg-type]

        # Рекурсивно обходим все значения словаря
        for v in obj.values():  # type: ignore[misc]
            extract_from_nested(v, key, results)

    elif isinstance(obj, list):
        for item in obj:  # type: ignore[misc]
            extract_from_nested(item, key, results)


def extract_addresses(data: Dict[str, Any]) -> List[Dict[str, Any]]:
    """
    Извлекает все адреса (psc, город, улица, номер дома).
    """
    addresses: List[Dict[str, Any]] = []

    # Ищем адреса в разных местах
    def find_addresses(obj: Any) -> None:
        if isinstance(obj, dict):
            # Если это объект адреса
            if "psc" in obj or "obec" in obj:
                addr: Dict[str, Any] = {}
                if "psc" in obj and obj["psc"]:
                    addr["psc"] = obj["psc"]

                # Обрабатываем obec
                if "obec" in obj and obj["obec"]:
                    obec: Any = obj["obec"]  # type: ignore[misc]
                    if isinstance(obec, dict):
                        if "nazev" in obec:
                            addr["city"] = obec["nazev"]
                        elif "id" in obec:
                            # Извлекаем ID из строки "Obec/554499"
                            city_id: Any = obec["id"]  # type: ignore[misc]
                            if isinstance(city_id, str) and "/" in city_id:
                                addr["city_id"] = city_id.split("/")[-1]
                            else:
                                addr["city_id"] = str(city_id)  # type: ignore[arg-type] # type: ignore[arg-type]
                    elif isinstance(obec, str):
                        addr["city"] = obec

                # Добавляем улицу
                if "ulice" in obj and obj["ulice"]:
                    ulice: Any = obj["ulice"]  # type: ignore[misc]
                    if isinstance(ulice, dict) and "nazev" in ulice:
                        addr["street"] = ulice["nazev"]
                    elif isinstance(ulice, str):
                        addr["street"] = ulice

                # Добавляем номер дома
                if "cisloDomovni" in obj and obj["cisloDomovni"]:
                    addr["house_number"] = str(obj["cisloDomovni"])  # type: ignore[arg-type]

                # Добавляем ориентационный номер
                if "cisloOrientacni" in obj and obj["cisloOrientacni"]:
                    addr["orientation_number"] = str(obj["cisloOrientacni"])  # type: ignore[arg-type]

                if addr:
                    addresses.append(addr)

            # Рекурсивно обходим
            for v in obj.values():  # type: ignore[misc]
                find_addresses(v)

        elif isinstance(obj, list):
            for item in obj:  # type: ignore[misc]
                find_addresses(item)

    find_addresses(data)
    return addresses


def extract_contacts(data: Dict[str, Any]) -> List[str]:
    """
    Извлекает контактные email адреса.
    """
    emails: Set[str] = set()

    # Ищем поля с email
    extract_from_nested(data, "email", emails)

    # Также ищем массивы emaily
    if "emaily" in str(data):

        def find_emails(obj: Any) -> None:
            if isinstance(obj, dict):
                if "emaily" in obj and isinstance(obj["emaily"], list):
                    for email_obj in obj["emaily"]:  # type: ignore[misc]
                        if isinstance(email_obj, dict) and "email" in email_obj:
                            emails.add(email_obj["email"])  # type: ignore[arg-type]
                for v in obj.values():  # type: ignore[misc]
                    find_emails(v)
            elif isinstance(obj, list):
                for item in obj:  # type: ignore[misc]
                    find_emails(item)

        find_emails(data)

    return list(emails)


def extract_phones(data: Dict[str, Any]) -> List[str]:
    """
    Извлекает телефонные номера.
    """
    phones: Set[str] = set()

    # Ищем поля telefon, telefonniCislo
    extract_from_nested(data, "telefon", phones)
    extract_from_nested(data, "telefonniCislo", phones)

    # Также ищем массивы telefony
    def find_phones(obj: Any) -> None:
        if isinstance(obj, dict):
            if "telefony" in obj and isinstance(obj["telefony"], list):
                for phone_obj in obj["telefony"]:  # type: ignore[misc]
                    if isinstance(phone_obj, dict):
                        if "telefonniCislo" in phone_obj:
                            phones.add(phone_obj["telefonniCislo"])  # type: ignore[arg-type]
                        elif "telefon" in phone_obj:
                            phones.add(phone_obj["telefon"])  # type: ignore[arg-type]
            for v in obj.values():  # type: ignore[misc]
                find_phones(v)
        elif isinstance(obj, list):
            for item in obj:  # type: ignore[misc]
                find_phones(item)

    find_phones(data)
    return list(phones)


def extract_persons(data: Dict[str, Any]) -> List[Dict[str, str]]:
    """
    Извлекает имена людей (vedouci, statutarni organy).
    """
    persons: List[Dict[str, str]] = []

    def find_persons(obj: Any) -> None:
        if isinstance(obj, dict):
            # Ведущий (vedouci)
            if "vedouci" in obj and isinstance(obj["vedouci"], dict):
                vedouci: Dict[str, Any] = obj["vedouci"]  # type: ignore[misc]
                person: Dict[str, str] = {}
                if "jmeno" in vedouci:
                    person["first_name"] = vedouci["jmeno"]
                if "prijmeni" in vedouci:
                    person["last_name"] = vedouci["prijmeni"]
                if "titulPred" in vedouci:
                    person["title_before"] = vedouci["titulPred"]
                if "titulZa" in vedouci:
                    person["title_after"] = vedouci["titulZa"]
                if person:
                    persons.append(person)

            # Statutарные органы
            if "statutarniOrgany" in obj and isinstance(obj["statutarniOrgany"], list):
                for organ in obj["statutarniOrgany"]:  # type: ignore[misc]
                    if isinstance(organ, dict):
                        person: Dict[str, str] = {}
                        if "jmeno" in organ:
                            person["first_name"] = organ["jmeno"]
                        if "prijmeni" in organ:
                            person["last_name"] = organ["prijmeni"]
                        if "titulPred" in organ:
                            person["title_before"] = organ["titulPred"]
                        if "titulZa" in organ:
                            person["title_after"] = organ["titulZa"]
                        if "funkcniObdobi" in organ:
                            person["function_period"] = organ["funkcniObdobi"]
                        if person:
                            persons.append(person)

            # Рекурсивно обходим
            for v in obj.values():  # type: ignore[misc]
                find_persons(v)

        elif isinstance(obj, list):
            for item in obj:  # type: ignore[misc]
                find_persons(item)

    find_persons(data)
    return persons


def extract_organizations(data: Dict[str, Any]) -> List[str]:
    """
    Извлекает названия организаций.
    """
    orgs: Set[str] = set()

    # Ищем nazev в poskytovatel и zarizeni
    def find_orgs(obj: Any, parent_key: str = "") -> None:
        if isinstance(obj, dict):
            # Если это poskytovatel или zarizeni с nazev
            if "nazev" in obj and isinstance(obj["nazev"], str):
                if parent_key in ["poskytovatel", "zarizeni", ""] or "nazev" in str(
                    obj.keys()  # type: ignore[arg-type]
                ):
                    orgs.add(obj["nazev"])

            for k, v in obj.items():  # type: ignore[misc]
                find_orgs(v, k)  # type: ignore[arg-type]

        elif isinstance(obj, list):
            for item in obj:  # type: ignore[misc]
                find_orgs(item, parent_key)

    find_orgs(data)
    return list(orgs)


def extract_websites(data: Dict[str, Any]) -> List[str]:
    """
    Извлекает веб-сайты.
    """
    websites: Set[str] = set()

    # Ищем www поля
    extract_from_nested(data, "www", websites)

    # Также ищем массивы weby
    def find_webs(obj: Any) -> None:
        if isinstance(obj, dict):
            if "weby" in obj and isinstance(obj["weby"], list):
                for web_obj in obj["weby"]:  # type: ignore[misc]
                    if isinstance(web_obj, dict) and "www" in web_obj:
                        websites.add(web_obj["www"])  # type: ignore[arg-type]
            for v in obj.values():  # type: ignore[misc]
                find_webs(v)
        elif isinstance(obj, list):
            for item in obj:  # type: ignore[misc]
                find_webs(item)

    find_webs(data)
    return list(websites)


def remove_duplicates(items: List[Any]) -> List[Any]:
    """
    Удаляет дубликаты из списка, сохраняя порядок.
    Для словарей использует JSON представление для сравнения.
    """
    seen: Set[str] = set()
    unique: List[Any] = []
    for item in items:
        # Для словарей используем сортированное JSON представление
        if isinstance(item, dict):
            key = json.dumps(item, sort_keys=True, ensure_ascii=False)
        else:
            key = item

        if key not in seen:
            seen.add(key)
            unique.append(item)

    return unique


def extract_record(record: Dict[str, Any]) -> Dict[str, Any]:
    """
    Извлекает все необходимые поля из одной записи.
    """
    extracted = {
        "addresses": remove_duplicates(extract_addresses(record)),
        "contacts": remove_duplicates(extract_contacts(record)),
        "phones": remove_duplicates(extract_phones(record)),
        "persons": remove_duplicates(extract_persons(record)),
        "organizations": remove_duplicates(extract_organizations(record)),
        "websites": remove_duplicates(extract_websites(record)),
    }

    # Добавляем идентификатор если есть
    if "portalId" in record:
        extracted["portal_id"] = record["portalId"]
    if "identifikator" in record:
        extracted["identifier"] = record["identifikator"]

    return extracted


def process_json_file(input_file: str, output_file: str) -> None:
    """
    Обрабатывает входной JSON файл и создает упрощенный выходной файл.
    """
    print(f"Читаем файл: {input_file}")

    with open(input_file, "r", encoding="utf-8") as f:
        data: Any = json.load(f)

    # Проверяем структуру
    records: List[Any]
    if isinstance(data, dict) and "polozky" in data:
        records = data["polozky"]  # type: ignore[misc]
        print(f"Найдено записей: {len(records)}")  # type: ignore[assignment]
    elif isinstance(data, list):
        records = data  # type: ignore[assignment]
        print(f"Найдено записей: {len(records)}")
    else:
        print("Ошибка: неизвестная структура JSON")
        sys.exit(1)

    # Обрабатываем записи
    extracted_records: List[Dict[str, Any]] = []
    for i, record in enumerate(records, 1):
        if i % 100 == 0:
            print(f"Обработано: {i}/{len(records)}")

        extracted = extract_record(record)
        extracted_records.append(extracted)

    # Сохраняем результат
    print(f"Сохраняем в файл: {output_file}")
    with open(output_file, "w", encoding="utf-8") as f:
        json.dump(
            {"total_records": len(extracted_records), "records": extracted_records},
            f,
            ensure_ascii=False,
            indent=2,
        )

    print(f"Готово! Обработано {len(extracted_records)} записей")
    print(f"Размер выходного файла: {len(json.dumps(extracted_records))} байт")


def main():
    """
    Главная функция.
    """
    if len(sys.argv) < 2:
        print("Использование: python3 extract_data.py <input.json> [output.json]")
        print("Пример: python3 extract_data.py test.json extracted_data.json")
        sys.exit(1)

    input_file = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else "extracted_data.json"

    try:
        process_json_file(input_file, output_file)
    except FileNotFoundError:
        print(f"Ошибка: файл {input_file} не найден")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Ошибка: невалидный JSON - {e}")
        sys.exit(1)
    except Exception as e:
        print(f"Ошибка: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)


if __name__ == "__main__":
    main()
