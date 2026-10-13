#!/usr/bin/env python3
"""Split xlsx workbook(s) into a folder of CSVs, one per sheet.

Usage: xlsx_to_csvs.py XLSX [XLSX ...]
Output: <name>/ folder next to each workbook, containing <sheet>.csv files.
Existing folders are never reused (_2, _3, ... is appended). CSVs are UTF-8 with BOM
so Excel opens accented characters correctly. Cells are written as stored (formulas
export their last calculated value).
"""
import csv, re, sys
from pathlib import Path

import openpyxl


def safe_name(name, used):
    base = re.sub(r'[\\/:*?"<>|]', "_", name).strip() or "Sheet"
    out, n = base, 1
    while out.lower() in used:
        n += 1
        out = f"{base}_{n}"
    used.add(out.lower())
    return out


def free_dir(path):
    out, n = path, 1
    while out.exists():
        n += 1
        out = path.with_name(f"{path.name}_{n}")
    return out


def cell(v):
    if v is None:
        return ""
    if isinstance(v, float) and v.is_integer():
        return int(v)
    return v


def main():
    files = [Path(p) for p in sys.argv[1:]]
    if not files:
        sys.exit("Usage: xlsx_to_csvs.py XLSX [XLSX ...]")

    for xlsx in files:
        wb = openpyxl.load_workbook(xlsx, read_only=True, data_only=True)  # read before mkdir
        out = free_dir(xlsx.parent / xlsx.stem)
        out.mkdir()
        used = set()
        for ws in wb.worksheets:
            path = out / f"{safe_name(ws.title, used)}.csv"
            n = 0
            with open(path, "w", newline="", encoding="utf-8-sig") as f:
                w = csv.writer(f)
                for row in ws.iter_rows(values_only=True):
                    w.writerow([cell(v) for v in row])
                    n += 1
            print(f"  + {path.name}: {n} rows")
        wb.close()
        print(f"Done: {out}")


if __name__ == "__main__":
    main()
