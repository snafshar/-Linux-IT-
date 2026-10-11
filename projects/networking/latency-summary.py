#!/usr/bin/env python3
"""Summarise latency samples from command-line arguments."""
import statistics
import sys

values = [float(x) for x in sys.argv[1:]]
if not values:
    raise SystemExit("usage: latency-summary.py 1.2 1.5 1.8")
print(f"count: {len(values)}")
print(f"min: {min(values):.3f} ms")
print(f"mean: {statistics.mean(values):.3f} ms")
print(f"median: {statistics.median(values):.3f} ms")
print(f"max: {max(values):.3f} ms")
