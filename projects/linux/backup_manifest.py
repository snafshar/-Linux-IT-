"""Create a SHA-256 manifest for files in a backup directory."""
from hashlib import sha256
from pathlib import Path
import sys


def manifest(root: Path) -> list[str]:
    if not root.is_dir():
        raise ValueError(f"not a directory: {root}")
    rows = []
    for path in sorted(p for p in root.rglob("*") if p.is_file()):
        digest = sha256(path.read_bytes()).hexdigest()
        rows.append(f"{digest}  {path.relative_to(root).as_posix()}")
    return rows


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python backup_manifest.py DIRECTORY")
    for row in manifest(Path(sys.argv[1])):
        print(row)
