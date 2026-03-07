import requests
import os
import pathlib
from urllib.parse import urlparse

SPARQL_ENDPOINT = "https://data.gov.cz/sparql"
DOWNLOAD_DIR = (
    pathlib.Path(__file__).parent.parent.parent.parent.parent / "datasets" / "nkod"
)

KEYWORDS = [
    "senior",
    "senioř",
    "důchod",
    "duchod",
    "důchodc",
    "starob",
    "stáří",
    "penz",
    "elderly",
]

os.makedirs(DOWNLOAD_DIR, exist_ok=True)


def run_sparql(query: str) -> dict:  # type: ignore
    params = {"query": query, "format": "json"}
    r = requests.get(SPARQL_ENDPOINT, params=params, timeout=120)
    r.raise_for_status()
    return r.json()


def find_datasets() -> list[dict[str, str]]:
    keyword_filter = " || ".join(
        [f'CONTAINS(LCASE(STR(?label)), "{k}")' for k in KEYWORDS]
    )

    query = f"""
    PREFIX dcat: <http://www.w3.org/ns/dcat#>
    PREFIX dct: <http://purl.org/dc/terms/>

    SELECT DISTINCT ?dataset ?label ?distribution
    WHERE {{
        GRAPH ?g {{
            ?dataset a dcat:Dataset ;
                     dct:title ?label ;
                     dcat:distribution ?dist .

            ?dist dcat:downloadURL ?distribution .
        }}

        FILTER({keyword_filter})
    }}
    """

    data = run_sparql(query)  # type: ignore

    results: list[dict[str, str]] = []

    for row in data["results"]["bindings"]:  # type: ignore
        url = row["distribution"]["value"]  # type: ignore
        if not url.endswith(".csv"):  # type: ignore
            continue

        results.append(
            {
                "dataset": row["dataset"]["value"],
                "label": row["label"]["value"],
                "url": url,
            }
        )

    return results


def download_file(url: str):
    filename = os.path.basename(urlparse(url).path)

    if not filename:
        filename = "dataset"

    path = os.path.join(DOWNLOAD_DIR, filename)

    if os.path.exists(path):
        print("SKIP:", filename)
        return

    print("DOWNLOAD:", url)

    r = requests.get(url, stream=True, timeout=120)
    r.raise_for_status()

    with open(path, "wb") as f:
        for chunk in r.iter_content(8192):
            f.write(chunk)


print(DOWNLOAD_DIR)
