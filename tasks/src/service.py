from typing import Any
from pathlib import Path
import asyncio
import json
import shutil
import zipfile
import requests
from bs4 import BeautifulSoup
from playwright.async_api import async_playwright, Download
from datetime import date

from .exceptions import NoLawsFoundError


class ParseDocsService:
    _LAW_JSON_ENDPOINT = "http://backend:8000/api/law"
    _LAW_PDF_ENDPOINT = "hhtp://backend:8000/api/..."

    def _extract_json_from_zip(self, zip_path: Path) -> list[Path]:
        if not zip_path.exists():
            return []

        target_dir = zip_path.parent
        extracted: list[Path] = []
        with zipfile.ZipFile(zip_path, "r") as archive:
            for member in archive.namelist():
                if not member.lower().endswith(".json"):
                    continue

                target_path = target_dir / Path(member).name
                with archive.open(member) as src, open(target_path, "wb") as dst:
                    shutil.copyfileobj(src, dst)
                extracted.append(target_path)

        zip_path.unlink(missing_ok=True)
        return extracted

    def _post_json_file(self, json_path: Path) -> None:
        with open(json_path, "r", encoding="utf-8") as handle:
            payload = json.load(handle)

        response = requests.post(self._LAW_JSON_ENDPOINT, json=payload, timeout=30)
        response.raise_for_status()

    def _save_pdf_file(self, pdf_path: Path) -> Path | None:
        if not pdf_path.exists():
            return None

        target_dir = Path("../../downloaded_laws")
        target_dir.mkdir(exist_ok=True)
        target_path = target_dir / pdf_path.name

        if pdf_path.resolve() != target_path.resolve():
            shutil.move(str(pdf_path), str(target_path))
            return target_path

        return target_path

    def _post_pdf_file(self, pdf_path: Path) -> None:
        with open(pdf_path, "rb") as handle:
            files = {"file": (pdf_path.name, handle, "application/pdf")}
            response = requests.post(self._LAW_PDF_ENDPOINT, files=files, timeout=30)
        response.raise_for_status()

    async def _parse_links(self) -> list[dict[str, Any]]:
        url = "https://e-sbirka.gov.cz/rejstriky/aktualne-vyhlasene-predpisy"
        async with async_playwright() as p:
            browser = await p.chromium.launch()
            page = await browser.new_page()
            await page.goto(url)
            await page.wait_for_load_state("networkidle")

            content = await page.content()
            soup = BeautifulSoup(content, "html.parser")

        laws: list[dict[str, Any]] = []

        rows = soup.find_all("tr", class_="pravni-akt-row")

        for row in rows:
            try:
                # (link text)
                law_num_elem = row.find(
                    "a",
                    class_=lambda x: x and "ng-star-inserted" in x,  # type: ignore
                )
                if not law_num_elem:
                    continue

                law_link = law_num_elem.get("href", "")

                # Parse data
                date_text = (
                    row.find_all("td")[-1].get_text(strip=True)
                    if row.find_all("td")
                    else ""
                )

                laws.append(
                    {
                        "date": date_text,
                        "link": f"https://e-sbirka.gov.cz{law_link}"
                        if law_link
                        else "",
                    }
                )
            except Exception as e:
                print(f"Error parsing row: {e}")
                continue

        await browser.close()
        return laws

    def _check_if_today(self, date_str: str) -> bool:
        today = date.today()
        today_str = today.strftime("%-d. %-m. %Y")  # "5. 5. 2026"
        today_iso = today.isoformat()  # "2026-05-05"

        return date_str.strip() == today_str or date_str.strip() == today_iso

    async def parse_page_json(self, urls: list[str]) -> None:
        Path("../../downloaded_laws").mkdir(exist_ok=True)

        async with async_playwright() as p:
            for url in urls:
                browser = await p.chromium.launch()
                page = await browser.new_page()

                # Extract law number for filename
                law_num = url.split("/")[-1]

                # Setup download handler
                async def handle_download(download: Download) -> None:
                    filename = f"downloaded_laws/{law_num}.zip"
                    await download.save_as(filename)
                    print(f"Saved: {filename}")
                    extracted = await asyncio.to_thread(
                        self._extract_json_from_zip, Path(filename)
                    )
                    for json_path in extracted:
                        await asyncio.to_thread(self._post_json_file, json_path)

                page.on("download", handle_download)

                await page.goto(url)
                await page.wait_for_load_state("networkidle")

                print(f"Opened: {url}")

                # Click download button in menu
                try:
                    download_btn = page.locator(".menu-item-2")
                    if await download_btn.is_visible(timeout=3000):
                        print("Clicking download button...")
                        await download_btn.click()
                        # Wait for popup to appear
                        await page.wait_for_timeout(2000)

                        # Find <a> tag inside esel-asynchronni-odkaz-ke-stazeni element
                        # Filter to get only ZIP link and take the first one
                        download_link_elem = (
                            page.locator("esel-asynchronni-odkaz-ke-stazeni a")
                            .filter(has_text="ZIP")
                            .first
                        )

                        if await download_link_elem.is_visible(timeout=3000):
                            print("Found ZIP download link, clicking...")

                            # Click the ZIP link
                            await download_link_elem.click()
                            # Wait for download to start
                            await page.wait_for_timeout(3000)
                            print("File download started")
                        else:
                            print("Download link not visible")
                    else:
                        print("Download button not visible")
                except Exception as e:
                    print(f"Error: {e}")

                await browser.close()

    async def parse_page_pdf(self, urls: list[str]) -> None:
        Path("../../downloaded_laws").mkdir(exist_ok=True)

        async with async_playwright() as p:
            for url in urls:
                browser = await p.chromium.launch()
                page = await browser.new_page()

                # Extract law number for filename
                law_num = url.split("/")[-1]

                # Setup download handler
                async def handle_download(download: Download) -> None:
                    filename = f"downloaded_laws/{law_num}.pdf"
                    await download.save_as(filename)
                    print(f"Saved: {filename}")
                    pdf_path = await asyncio.to_thread(
                        self._save_pdf_file, Path(filename)
                    )
                    if pdf_path is not None:
                        await asyncio.to_thread(self._post_pdf_file, pdf_path)

                page.on("download", handle_download)

                await page.goto(url)
                await page.wait_for_load_state("networkidle")

                print(f"Opened: {url}")

                # Click download button in menu
                try:
                    download_btn = page.locator(".menu-item-2")
                    if await download_btn.is_visible(timeout=3000):
                        print("Clicking download button...")
                        await download_btn.click()
                        # Wait for popup to appear
                        await page.wait_for_timeout(2000)

                        # Find <a> tag inside esel-asynchronni-odkaz-ke-stazeni element
                        # Filter to get only ZIP link and take the first one
                        download_link_elem = (
                            page.locator("esel-asynchronni-odkaz-ke-stazeni a")
                            .filter(has_text="PDF")
                            .first
                        )

                        if await download_link_elem.is_visible(timeout=3000):
                            print("Found PDF download link, clicking...")

                            # Click the ZIP link
                            await download_link_elem.click()
                            # Wait for download to start
                            await page.wait_for_timeout(3000)
                            print("File download started")
                        else:
                            print("Download link not visible")
                    else:
                        print("Download button not visible")
                except Exception as e:
                    print(f"Error: {e}")

                await browser.close()

    async def parse_json(self) -> None:
        links = await self._parse_links()
        if not links:
            raise NoLawsFoundError("Any new laws not found")

        today_laws = [link for link in links if self._check_if_today(link["date"])]
        if not today_laws:
            raise NoLawsFoundError("Any new laws not found")

        urls: list[str] = []
        for law in today_laws:
            urls.append(law["link"])

        await self.parse_page_json(urls)

    async def parse_pdf(self) -> None:
        links = await self._parse_links()
        if not links:
            raise NoLawsFoundError("Any new laws not found")

        today_laws = [link for link in links if self._check_if_today(link["date"])]
        if not today_laws:
            raise NoLawsFoundError("Any new laws not found")

        urls: list[str] = []
        for law in today_laws:
            urls.append(law["link"])

        await self.parse_page_pdf(urls)
