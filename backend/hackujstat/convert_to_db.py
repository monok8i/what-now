#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Скрипт для перетворення текстових файлів у формат для бази даних BenefitService
"""

import json
import re
import uuid
from pathlib import Path
from typing import Dict, List, Any, Optional
import sqlite3
import hashlib

class SocialBenefitParser:
    def __init__(self):
        self.category_mapping = {
            'finance-prispevky': 'prispevek_na_peci',
            'kompenzacni-pomucky-upravy-bytu': 'kompenzacni_pomucky',
            'pravo-zastupovani': 'pravni_zastupovani',
            'typy-pece-sluzeb': 'socialni_sluzby'
        }
        
        self.institution_patterns = {
            'Úřad práce ČR': ['úřad práce', 'up čr', 'úp čr', 'uradprace'],
            'ČSSZ': ['čssz', 'česká správa sociálního zabezpečení', 'sociální zabezpečení'],
            'MPSV': ['mpsv', 'ministerstvo práce', 'sociálních věcí'],
            'Zdravotní pojišťovna': ['zdravotní pojišťovna', 'pojišťovna', 'zdravotní pojištění'],
            'Soud': ['soud', 'soudní', 'opatrovnictví', 'opatrovník']
        }
    
    def extract_conditions_from_text(self, text: str) -> Dict[str, Any]:
        """Extrahuje podmínky z textu a vytváří JSONB strukturu."""
        conditions = {}
        
        # Věkové limity
        age_patterns = [
            r'věk.*?(\d+).*?let',
            r'od\s+(\d+)\s+let',
            r'do\s+(\d+)\s+let',
            r'pod\s+(\d+)\s+let'
        ]
        
        ages = []
        for pattern in age_patterns:
            matches = re.findall(pattern, text, re.IGNORECASE)
            ages.extend([int(age) for age in matches])
        
        if ages:
            conditions['vek_min'] = min(ages) if 'od' in text.lower() or 'nad' in text.lower() else 0
            conditions['vek_max'] = max(ages) if 'do' in text.lower() or 'pod' in text.lower() else None
        
        # Stupeň závislosti
        dependency_pattern = r'(\d)\.\s*stupe[nň]'
        dependency_matches = re.findall(dependency_pattern, text)
        if dependency_matches:
            conditions['stupen_zavislosti'] = int(dependency_matches[0])
        
        # Typ závislosti
        if 'těžká' in text.lower():
            conditions['typ_zavislosti'] = 'těžká'
        elif 'střední' in text.lower():
            conditions['typ_zavislosti'] = 'střední'
        elif 'lehká' in text.lower():
            conditions['typ_zavislosti'] = 'lehká'
        
        # Průkazy OZP
        prukaz_patterns = ['ztp/p', 'ztp', 'ozp']
        found_prukazy = []
        for prukaz in prukaz_patterns:
            if prukaz in text.lower():
                found_prukazy.append(prukaz.upper())
        
        if found_prukazy:
            conditions['prukazy_ozp'] = found_prukazy
        
        # Status zaměstnání
        if 'zaměstnanec' in text.lower():
            conditions['status_zamestnani'] = 'zamestnanec'
        elif 'důchodce' in text.lower():
            conditions['status_zamestnani'] = 'duchodce'
        elif 'nezaměstnaný' in text.lower():
            conditions['status_zamestnani'] = 'nezamestnaný'
        
        # Délka hospitalizace
        hosp_pattern = r'(\d+)\s*dn[ůuí]'
        hosp_matches = re.findall(hosp_pattern, text)
        if hosp_matches and 'hospitaliz' in text.lower():
            conditions['delka_hospitalizace_min'] = int(hosp_matches[0])
        
        # Região - hledáme města a regiony
        regions = ['praha', 'brno', 'ostrava', 'plzeň', 'liberec', 'olomouc', 'hradec králové', 'pardubice', 'zlín', 'karlovy vary']
        for region in regions:
            if region in text.lower():
                conditions['region'] = region.title()
                break
        
        # Living arrangement
        if 'doma' in text.lower() and 'péče' in text.lower():
            conditions['living_arrangement'] = 'u_me_doma'
        elif 'ústavní' in text.lower():
            conditions['living_arrangement'] = 'ustav'
        elif 'domov' in text.lower() and 'senior' in text.lower():
            conditions['living_arrangement'] = 'domov_senioru'
        
        return conditions
    
    def detect_institution(self, text: str) -> str:
        """Detekuje zodpovědnou instituci z textu."""
        text_lower = text.lower()
        
        for institution, patterns in self.institution_patterns.items():
            for pattern in patterns:
                if pattern in text_lower:
                    return institution
        
        # Default fallback
        return 'Úřad práce ČR'
    
    def split_into_sections(self, text: str, filename: str) -> List[Dict[str, Any]]:
        """Rozdělí text na logické sekce pro databázi."""
        sections = []
        
        # Rozdělujeme podle číslování nebo nadpisů
        section_pattern = r'(\d+\.?\s*[^\n]+)\n([^]*?)(?=\n\d+\.|\n[A-ZÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ][^a-záčďéěíňóřšťúůýž\n]*:|\Z)'
        matches = re.findall(section_pattern, text, re.MULTILINE)
        
        if not matches:
            # Pokud nejsou sekce, použijeme celý text
            sections.append({
                'name': f'Informace - {filename}',
                'content': text,
                'number': 1
            })
        else:
            for i, (title, content) in enumerate(matches, 1):
                clean_title = re.sub(r'^\d+\.?\s*', '', title).strip()
                sections.append({
                    'name': clean_title,
                    'content': content.strip(),
                    'number': i
                })
        
        return sections
    
    def extract_next_steps(self, text: str) -> Optional[List[str]]:
        """Extrahuje další kroky z textu."""
        steps = []
        
        # Hledáme kontrolní seznamy nebo kroky
        checklist_pattern = r'\[\s*\]\s*([^\n]+)'
        checklist_matches = re.findall(checklist_pattern, text)
        if checklist_matches:
            steps.extend(checklist_matches)
        
        # Hledáme číslovné kroky
        step_pattern = r'(\d+\.)\s*([^\n]+)'
        step_matches = re.findall(step_pattern, text)
        if step_matches and len(step_matches) > 1:  # Více než jeden krok
            steps.extend([step[1] for step in step_matches])
        
        return steps if steps else None
    
    def generate_id(self, text: str) -> str:
        """Generuje unikátní ID na základě obsahu."""
        content_hash = hashlib.md5(text.encode('utf-8')).hexdigest()
        return f"benefit_{content_hash[:8]}"
    
    def process_file(self, filepath: Path) -> List[Dict[str, Any]]:
        """Zpracuje jeden soubor a vrátí seznam záznamů pro databázi."""
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
        except UnicodeDecodeError:
            # Pokus o jiné kódování
            with open(filepath, 'r', encoding='cp1250') as f:
                content = f.read()
        
        filename = filepath.stem
        category = self.category_mapping.get(filename, 'ostatni')
        
        sections = self.split_into_sections(content, filename)
        records = []
        
        for section in sections:
            full_text = section['content']
            
            record = {
                'id': self.generate_id(f"{filename}_{section['number']}_{section['name']}"),
                'category': category,
                'institution': self.detect_institution(full_text),
                'name': section['name'][:255],  # Omezení délky
                'content_text': full_text,
                'conditions': self.extract_conditions_from_text(full_text),
                'source_id': filename,
                'next_steps': self.extract_next_steps(full_text)
            }
            
            records.append(record)
        
        return records
    
    def export_to_json(self, records: List[Dict[str, Any]], output_file: str):
        """Exportuje záznamy do JSON souboru."""
        with open(output_file, 'w', encoding='utf-8') as f:
            json.dump(records, f, ensure_ascii=False, indent=2)
    
    def export_to_sql(self, records: List[Dict[str, Any]], output_file: str):
        """Generuje SQL INSERT příkazy."""
        sql_statements = []
        
        # CREATE TABLE statement
        create_table = """
CREATE TABLE IF NOT EXISTS benefit_services (
    id VARCHAR(255) PRIMARY KEY,
    category VARCHAR(255) NOT NULL,
    institution VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    content_text TEXT NOT NULL,
    conditions JSONB NOT NULL,
    source_id VARCHAR(255),
    next_steps JSON
);

CREATE INDEX IF NOT EXISTS idx_benefit_category ON benefit_services(category);
CREATE INDEX IF NOT EXISTS idx_benefit_institution ON benefit_services(institution);
"""
        
        sql_statements.append(create_table)
        
        for record in records:
            conditions_json = json.dumps(record['conditions'], ensure_ascii=False)
            next_steps_json = json.dumps(record['next_steps'], ensure_ascii=False) if record['next_steps'] else 'NULL'
            
            # Pro SQLite používáme JSON místo JSONB
            insert_sql = f"""INSERT INTO benefit_services 
(id, category, institution, name, content_text, conditions, source_id, next_steps) 
VALUES (
    '{record['id']}',
    '{record['category']}',
    '{record['institution']}',
    '{record['name'].replace("'", "''")}',
    '{record['content_text'].replace("'", "''")}',
    '{conditions_json.replace("'", "''")}',
    '{record['source_id']}',
    {next_steps_json if next_steps_json != 'NULL' else 'NULL'}
);"""
            
            sql_statements.append(insert_sql)
        
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write('\n\n'.join(sql_statements))
    
    def create_summary_report(self, records: List[Dict[str, Any]]) -> str:
        """Vytváří souhrnnou zpráву o zpracovaných datech."""
        total_records = len(records)
        categories = {}
        institutions = {}
        
        for record in records:
            cat = record['category']
            inst = record['institution']
            
            categories[cat] = categories.get(cat, 0) + 1
            institutions[inst] = institutions.get(inst, 0) + 1
        
        report = f"""
SOUHRN ZPRACOVANÝCH DAT
======================

Celkem záznamů: {total_records}

Rozdělení podle kategorií:
"""
        for cat, count in sorted(categories.items()):
            report += f"  - {cat}: {count} záznamů\n"
        
        report += f"\nRozdělení podle institucí:\n"
        for inst, count in sorted(institutions.items()):
            report += f"  - {inst}: {count} záznamů\n"
        
        return report


def main():
    parser = SocialBenefitParser()
    workspace_path = Path('/home/ezno/hackujstat')
    
    # Najdeme všechny relevantní soubory
    files_to_process = [
        workspace_path / 'finance-prispevky',
        workspace_path / 'kompenzacni-pomucky-upravy-bytu', 
        workspace_path / 'pravo-zastupovani',
        workspace_path / 'typy-pece-sluzeb'
    ]
    
    all_records = []
    
    print("🔄 Začínám zpracování souborů...")
    
    for file_path in files_to_process:
        if file_path.exists():
            print(f"   📄 Zpracovávám: {file_path.name}")
            try:
                records = parser.process_file(file_path)
                all_records.extend(records)
                print(f"      ✅ Vytvořeno {len(records)} záznamů")
            except Exception as e:
                print(f"      ❌ Chyba při zpracování {file_path.name}: {e}")
        else:
            print(f"   ⚠️  Soubor nenalezen: {file_path}")
    
    if not all_records:
        print("❌ Nebyly nalezeny žádné záznamy k zpracování!")
        return
    
    # Export do různých formátů
    output_dir = workspace_path / 'output'
    output_dir.mkdir(exist_ok=True)
    
    print(f"\n💾 Exportuji {len(all_records)} záznamů...")
    
    # JSON export
    json_file = output_dir / 'social_benefits.json'
    parser.export_to_json(all_records, str(json_file))
    print(f"   📄 JSON: {json_file}")
    
    # SQL export  
    sql_file = output_dir / 'social_benefits.sql'
    parser.export_to_sql(all_records, str(sql_file))
    print(f"   📄 SQL: {sql_file}")
    
    # Souhrnná zpráva
    summary = parser.create_summary_report(all_records)
    summary_file = output_dir / 'summary_report.txt'
    with open(summary_file, 'w', encoding='utf-8') as f:
        f.write(summary)
    
    print(f"   📋 Souhrn: {summary_file}")
    print("\n" + summary)
    
    print("\n✅ Zpracování dokončeno!")
    print(f"📂 Výsledky najdete ve složce: {output_dir}")


if __name__ == "__main__":
    main()