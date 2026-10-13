#!/usr/bin/env python3
"""Combine CSV file(s) into one .xlsx workbook, one sheet per CSV.

Usage: csvs_to_xlsx.py CSV [CSV ...]
Output: next to the first CSV. One CSV -> <name>.xlsx; several -> combined.xlsx.
Existing files are never overwritten (_2, _3, ... is appended).
"""
import re, sys
from pathlib import Path

import pandas as pd


def read_csv(path):
    # dtype=str keeps leading zeros / IDs intact; try common encodings
    for enc in ("utf-8-sig", "cp1252", "latin-1"):
        try:
            return pd.read_csv(path, dtype=str, keep_default_na=False, encoding=enc)
        except UnicodeDecodeError:
            continue
        except pd.errors.EmptyDataError:
            return pd.DataFrame()
    raise ValueError(f"Could not decode {path}")


def sheet_name(stem, used):
    """Excel: max 31 chars, none of : \\ / ? * [ ], unique case-insensitively."""
    base = re.sub(r"[:\\/?*\[\]]", "_", stem).strip("'")[:31] or "Sheet"
    name, n = base, 1
    while name.lower() in used:
        n += 1
        suffix = f"_{n}"
        name = base[:31 - len(suffix)] + suffix
    used.add(name.lower())
    return name


def free_path(path):
    out, n = path, 1
    while out.exists():
        n += 1
        out = path.with_name(f"{path.stem}_{n}{path.suffix}")
    return out


def main():
    csvs = [Path(p) for p in sys.argv[1:]]
    if not csvs:
        sys.exit("Usage: csvs_to_xlsx.py CSV [CSV ...]")

    first = csvs[0]
    out = free_path(first.with_suffix(".xlsx") if len(csvs) == 1
                    else first.parent / "combined.xlsx")

    used = set()
    with pd.ExcelWriter(out, engine="openpyxl") as writer:
        for csv in csvs:
            df = read_csv(csv)
            df.to_excel(writer, sheet_name=sheet_name(csv.stem, used), index=False)
            print(f"  + {csv.name}: {len(df)} rows")
    print(f"Done: {out}")


if __name__ == "__main__":
    main()
