"""Exporta las fichas del manual A2–B1 como datos para la aplicación estática."""

import json
from pathlib import Path
import sys
from xml.etree import ElementTree
from zipfile import ZipFile


ROOT = Path(__file__).resolve().parent
MANUAL = ROOT / "doc" / "Manual_ingles_A2_B1_4000_elementos.xlsx"
NS = {"x": "http://schemas.openxmlformats.org/spreadsheetml/2006/main"}
REL_ID = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"
SHEETS = {
    "construction": "Construcción",
    "tenses": "Tiempos verbales",
    "vocabulary": "Vocabulario 2000",
    "questions": "Preguntas y respuestas",
}


def read_manual(path):
    with ZipFile(path) as workbook:
        sheets = ElementTree.fromstring(workbook.read("xl/workbook.xml"))
        relations = ElementTree.fromstring(workbook.read("xl/_rels/workbook.xml.rels"))
        targets = {rel.attrib["Id"]: rel.attrib["Target"] for rel in relations}
        names = {sheet.attrib["name"]: targets[sheet.attrib[REL_ID]]
                 for sheet in sheets.findall("x:sheets/x:sheet", NS)}
        strings = []
        if "xl/sharedStrings.xml" in workbook.namelist():
            table = ElementTree.fromstring(workbook.read("xl/sharedStrings.xml"))
            strings = ["".join(node.itertext()) for node in table]

        for section, name in SHEETS.items():
            target = names[name]
            sheet_path = target.lstrip("/") if target.startswith("/") else f"xl/{target}"
            sheet = ElementTree.fromstring(workbook.read(sheet_path))
            for row in sheet.findall("x:sheetData/x:row", NS)[1:]:
                values = {}
                for cell in row:
                    value = cell.findtext("x:v", default="", namespaces=NS)
                    if cell.get("t") == "s":
                        value = strings[int(value)]
                    elif cell.get("t") == "inlineStr":
                        value = "".join(cell.find("x:is", NS).itertext())
                    column = cell.attrib["r"].rstrip("0123456789")
                    values[column] = value

                if not values.get("A"):
                    continue
                if section == "vocabulary":
                    yield section, {
                        "id": f"{section}:{values['A']}",
                        "english": values["B"],
                        "spanish": values.get("C", ""),
                    }
                    continue

                category = values["B"]
                card = {
                    "id": f"{section}:{category}:{values['A']}",
                    "category": category,
                    "english": values["C"],
                    "spanish": values["D"],
                }
                if section == "questions":
                    card["spanish"], answer = values["D"].split(" | ", 1)
                    card["answerEnglish"], card["answerSpanish"] = answer.split(" — ", 1)
                yield section, card


def export_manual(path):
    sections = {section: [] for section in SHEETS}
    ids = set()
    for section, card in read_manual(path):
        if card["id"] in ids or not card["english"]:
            raise ValueError(f"Ficha duplicada o sin texto en inglés: {card['id']}")
        ids.add(card["id"])
        sections[section].append(json.dumps(card, ensure_ascii=False))

    blocks = []
    for section, cards in sections.items():
        if not cards:
            raise ValueError(f"La sección {SHEETS[section]} está vacía")
        rows = ",\n".join(f"    {card}" for card in cards)
        blocks.append(f"  {section}: [\n{rows}\n  ]")
    data = ",\n".join(blocks)
    (ROOT / "manual-data.js").write_text(
        f"// Generado con import_manual.py.\nconst MANUAL_DATA = {{\n{data}\n}};\n",
        encoding="utf-8",
        newline="\n",
    )


if __name__ == "__main__":
    export_manual(Path(sys.argv[1]) if len(sys.argv) > 1 else MANUAL)
