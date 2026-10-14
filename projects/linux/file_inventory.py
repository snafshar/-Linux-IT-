"""Summarise file counts and byte totals without changing any files."""
from pathlib import Path
import sys


def inventory(root: Path) -> dict[str, int]:
    if not root.is_dir():
        raise ValueError(f"not a directory: {root}")
    files = [p for p in root.rglob("*") if p.is_file()]
    return {"files": len(files), "bytes": sum(p.stat().st_size for p in files)}


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python file_inventory.py DIRECTORY")
    result = inventory(Path(sys.argv[1]))
    print(f"Files: {result['files']}")
    print(f"Bytes: {result['bytes']}")
