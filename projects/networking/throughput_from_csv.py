"""Summarise throughput measurements from a CSV with a 'mbps' column."""
import csv
from pathlib import Path
import sys


def read_values(path: Path) -> list[float]:
    with path.open(newline="", encoding="utf-8") as handle:
        reader = csv.DictReader(handle)
        if not reader.fieldnames or "mbps" not in reader.fieldnames:
            raise ValueError("CSV must contain a 'mbps' column")
        values = [float(row["mbps"]) for row in reader]
    if not values or any(value < 0 for value in values):
        raise ValueError("measurements must be non-negative and non-empty")
    return values


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python throughput_from_csv.py measurements.csv")
    data = read_values(Path(sys.argv[1]))
    print(f"count={len(data)} min={min(data):.3f} mean={sum(data)/len(data):.3f} max={max(data):.3f} Mbps")
