#!/usr/bin/env python3
"""Count common severity words in a text log."""
import argparse
from collections import Counter
from pathlib import Path
import re

LEVEL = re.compile(r"\b(DEBUG|INFO|WARN|WARNING|ERROR|CRITICAL)\b", re.I)

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("log", type=Path)
    args = parser.parse_args()
    counts: Counter[str] = Counter()
    try:
        with args.log.open(encoding="utf-8", errors="replace") as stream:
            for line in stream:
                match = LEVEL.search(line)
                if match:
                    level = match.group(1).upper()
                    counts["WARN" if level == "WARNING" else level] += 1
    except OSError as exc:
        parser.error(str(exc))
    for name in ("CRITICAL", "ERROR", "WARN", "INFO", "DEBUG"):
        print(f"{name:8} {counts[name]}")
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
