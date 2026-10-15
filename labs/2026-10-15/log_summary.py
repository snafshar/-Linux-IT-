#!/usr/bin/env python3
"""Count common severity labels in a UTF-8 log file."""
from collections import Counter
from pathlib import Path
import argparse
import re
import sys

LEVELS = ("TRACE", "DEBUG", "INFO", "WARN", "WARNING", "ERROR", "CRITICAL")
PATTERN = re.compile(r"\b(" + "|".join(LEVELS) + r")\b", re.IGNORECASE)


def summarize(path: Path) -> tuple[int, Counter[str]]:
    counts: Counter[str] = Counter()
    lines = 0
    with path.open("r", encoding="utf-8", errors="replace") as stream:
        for line in stream:
            lines += 1
            match = PATTERN.search(line)
            if match:
                level = match.group(1).upper()
                if level == "WARNING":
                    level = "WARN"
                counts[level] += 1
    return lines, counts


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("logfile", type=Path)
    args = parser.parse_args()
    if not args.logfile.is_file():
        parser.error(f"not a file: {args.logfile}")
    try:
        lines, counts = summarize(args.logfile)
    except OSError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return 1
    print(f"Lines scanned: {lines}")
    for level in ("CRITICAL", "ERROR", "WARN", "INFO", "DEBUG", "TRACE"):
        print(f"{level:8} {counts[level]}")
    print(f"Other lines: {lines - sum(counts.values())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
