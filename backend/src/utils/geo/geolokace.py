#!/usr/bin/env python3
"""
Generuje CSV se sluzbami a adresami poskytovatelu z JSON souboru v poskytovatele/.

Vstup:  poskytovatele/0-99.json, poskytovatele/100-200.json, ...
Vystup: poskytovatele/0-99.csv, poskytovatele/0-99_adresy.csv
        poskytovatele/100-200.csv, poskytovatele/100-200_adresy.csv
        poskytovatele/2606.json (API response pro kazdeho poskytovatele)

Pouziti:
  python3 geolokace.py                          # vychozi: 0-99.json
  python3 geolokace.py poskytovatele/600-633.json
  python3 geolokace.py --all                    # zpracuje vsechny chunk JSON
"""
import json
import csv
import subprocess
import sys
import os
import glob as globmod
import time
import threading
import concurrent.futures
import requests

# --- Nastaveni ---
PROVIDERS_DIR = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'poskytovatele')
API_BASE = 'https://mpsv.gov.cz/api/api-gateway/rest/adresy/spojeni'
API_PARAMS = (
    'typSubjektu=PoskytovatelSocialniSluzbyFoNeboPo'
    '&kodTypuSpojeni=adrZar'
    '&v=1c5ef6f10dc808d49b3c1ddfa27e6ee9rpssv2'
)


# --- Extrahuj sluzba_id a poskytovatel_id z JSON do CSV ---
def extract_ids_from_json(input_file, output_csv):
    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    rows = []
    for item in data['list']:
        rows.append({
            'sluzba': item['sluzba']['id'],
            'poskytovatel': item['poskytovatel']['id'],
        })

    with open(output_csv, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=['sluzba', 'poskytovatel'])
        writer.writeheader()
        writer.writerows(rows)

    print(f'  {len(rows)} zaznamu v {os.path.basename(output_csv)}')
    return rows


# --- Stahni adresy z API pro kazdeho poskytovatele ---
def fetch_addresses(ids, providers_dir):
    provider_ids = sorted(set(r['poskytovatel'] for r in ids))
    print(f'  Stahuji adresy pro {len(provider_ids)} poskytovatelů...')

    def fetch_one(pid):
        json_path = os.path.join(providers_dir, f'{pid}.json')
        if os.path.isfile(json_path):
            return
        url = f'{API_BASE}?subjektId={pid}&{API_PARAMS}'
        subprocess.run(['curl', '-s', url, '-o', json_path], check=True, timeout=30)

    with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
        list(executor.map(fetch_one, provider_ids))

    print(f'  Hotovo')


# --- Geokodovani adresy na GPS souradnice (Photon) ---
_photon_cache = {}
_photon_cache_lock = threading.Lock()
_last_photon_time = 0
_photon_rate_lock = threading.Lock()
PHOTON_MIN_INTERVAL = 0.5  # Photon: min 0.5 sec mezi dotazy


def geocode_address(ulice, cislo, cast, obec, psc, kraj):
    global _last_photon_time

    key = f'{ulice} {cislo}, {cast} {psc} {obec}'
    with _photon_cache_lock:
        if key in _photon_cache:
            return _photon_cache[key]

    query = f'{ulice} {cislo}'.strip()
    if cast:
        query += f', {cast}'
    if obec:
        query += f', {obec}'
    if psc:
        query += f', {psc}'

    # Rate limiting
    with _photon_rate_lock:
        now = time.time()
        elapsed = now - _last_photon_time
        if elapsed < PHOTON_MIN_INTERVAL:
            time.sleep(PHOTON_MIN_INTERVAL - elapsed)
        _last_photon_time = time.time()

    url = f'https://photon.komoot.io/api?q={requests.utils.quote(query)}&limit=1'
    headers = {'User-Agent': 'geolokace-ceska-republika'}
    max_retries = 3
    for attempt in range(max_retries):
        try:
            resp = requests.get(url, headers=headers, timeout=10)
            if resp.status_code == 200:
                data = resp.json()
                if data.get('features'):
                    coords = data['features'][0]['geometry']['coordinates']
                    result = (coords[1], coords[0])  # [lon, lat] -> (lat, lon)
                    with _photon_cache_lock:
                        _photon_cache[key] = result
                    return result
            elif resp.status_code == 429:
                wait = (2 ** attempt) * 2
                print(f'    Rate limit (429), cekam {wait}s... (pokouseni {attempt+1}/{max_retries})')
                time.sleep(wait)
                with _photon_rate_lock:
                    _last_photon_time = time.time()
            else:
                print(f'    Chyba Photon API: {resp.status_code}')
            result = ('', '')
            with _photon_cache_lock:
                _photon_cache[key] = result
            return result
        except Exception as e:
            print(f'    Chyba geokodovani: {e}')
            result = ('', '')
            with _photon_cache_lock:
                _photon_cache[key] = result
            return result
    result = ('', '')
    with _photon_cache_lock:
        _photon_cache[key] = result
    return result


# --- Extrahuj strukturovanou adresu ---
def get_address(item):
    am = item['adresa']['strukturovanaAdresa']['adresniMisto']

    ulice = am.get('ulice', {})
    ulice_nazev = ulice.get('nazev', '') if isinstance(ulice, dict) else (str(ulice) or '')

    cislo = str(am.get('cisloDomovni', ''))
    cn = am.get('cisloOrientacni', '')
    if cn:
        cislo += '/' + str(cn)

    cast_obce = am.get('castObce', {})
    cast = cast_obce.get('nazev', '') if isinstance(cast_obce, dict) else (str(cast_obce) or '')

    obec = cast_obce.get('obec', {}) if isinstance(cast_obce, dict) else {}
    obec_nazev = obec.get('nazev', '') if isinstance(obec, dict) else (str(obec) or '')

    psc = am.get('psc', {})
    psc_kod = psc.get('kodPsc', '') if isinstance(psc, dict) else (str(psc) or '')

    kraj_nazev = obec.get('okres', {}).get('kraj', {}).get('nazev', '') if isinstance(obec, dict) else ''

    return {
        'ulice': ulice_nazev,
        'cislo': cislo,
        'cast': cast,
        'obec': obec_nazev,
        'psc': psc_kod,
        'kraj': kraj_nazev,
    }


# --- Spoj CSV s adresami ---
def build_addresses_csv(ids, output_csv):
    results = [None] * len(ids)

    def process_one(idx, row):
        sluzba = row['sluzba']
        poskytovatel = row['poskytovatel']
        json_path = os.path.join(PROVIDERS_DIR, f'{poskytovatel}.json')

        try:
            with open(json_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            if data.get('list'):
                addr = get_address(data['list'][0])
                gps = geocode_address(addr['ulice'], addr['cislo'], addr['cast'],
                                       addr['obec'], addr['psc'], addr['kraj'])
                result = {'sluzba': sluzba, 'poskytovatel_id': poskytovatel, **addr}
                result['lat'] = gps[0]
                result['lon'] = gps[1]
                results[idx] = result
            else:
                results[idx] = {'sluzba': sluzba, 'poskytovatel_id': poskytovatel,
                                'ulice': '', 'cislo': '', 'cast': '', 'obec': '',
                                'psc': '', 'kraj': '', 'lat': '', 'lon': ''}
        except Exception as e:
            results[idx] = {'sluzba': sluzba, 'poskytovatel_id': poskytovatel,
                            'ulice': f'CHYBA: {e}', 'cislo': '', 'cast': '', 'obec': '',
                            'psc': '', 'kraj': '', 'lat': '', 'lon': ''}

    with concurrent.futures.ThreadPoolExecutor(max_workers=3) as executor:
        futures = [executor.submit(process_one, i, row) for i, row in enumerate(ids)]
        for i, fut in enumerate(concurrent.futures.as_completed(futures)):
            fut.result()
            if (i + 1) % 25 == 0:
                print(f'    {i+1}/{len(ids)} ...')

    fields = ['sluzba', 'poskytovatel_id', 'ulice', 'cislo', 'cast', 'obec', 'psc', 'kraj', 'lat', 'lon']
    with open(output_csv, 'w', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        writer.writerows(results)

    print(f'  {len(results)} zaznamu v {os.path.basename(output_csv)}')


# --- Pomocne funkce ---
def basename_no_ext(filepath):
    return os.path.splitext(os.path.basename(filepath))[0]


def is_chunk_file(filepath):
    basename = os.path.basename(filepath)
    return '-' in basename


def main():
    use_all = '--all' in sys.argv

    # Vyber vstupni JSON soubory
    if use_all:
        all_jsons = globmod.glob(os.path.join(PROVIDERS_DIR, '*.json'))
        chunk_files = [f for f in all_jsons if is_chunk_file(f)]
    elif len(sys.argv) > 1:
        chunk_files = [sys.argv[1]]
    else:
        chunk_files = [os.path.join(PROVIDERS_DIR, '0-99.json')]

    chunk_files.sort(key=lambda f: basename_no_ext(f))

    print(f'Vstupni JSON: {[os.path.basename(f) for f in chunk_files]}')

    # Celkove ID pro stahovani adres
    all_ids = []

    for json_file in chunk_files:
        name = basename_no_ext(json_file)
        print(f'\nZpracovavam: {os.path.basename(json_file)}')

        # CSV pro sluzby (stejny nazev jako JSON)
        sluzby_csv = os.path.join(PROVIDERS_DIR, f'{name}.csv')
        ids = extract_ids_from_json(json_file, sluzby_csv)
        all_ids.extend(ids)

    print(f'\nCelkem {len(all_ids)} zaznamu')

    # Stahovani adres
    print(f'\nKrok 2: Stahovani adres...')
    fetch_addresses(all_ids, PROVIDERS_DIR)

    # Generovani adres pro kazdy chunk
    print(f'\nKrok 3: Generovani adres...')
    offset = 0
    for json_file in chunk_files:
        name = basename_no_ext(json_file)

        # Znovu nacti z CSV
        csv_path = os.path.join(PROVIDERS_DIR, f'{name}.csv')
        ids = []
        with open(csv_path, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                ids.append(row)

        addresses_csv = os.path.join(PROVIDERS_DIR, f'{name}_adresy.csv')
        build_addresses_csv(ids, addresses_csv)

        offset += len(ids)

    print('\nHotovo!')


if __name__ == '__main__':
    main()
