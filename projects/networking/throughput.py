#!/usr/bin/env python3
"""Calculate throughput from byte count and elapsed time."""
import argparse


def megabits_per_second(byte_count, seconds):
    if byte_count < 0 or seconds <= 0:
        raise ValueError("bytes must be non-negative and seconds positive")
    return byte_count * 8 / seconds / 1_000_000


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bytes", type=int, help="transferred bytes")
    parser.add_argument("seconds", type=float, help="elapsed seconds")
    args = parser.parse_args()
    print(f"{megabits_per_second(args.bytes, args.seconds):.3f} Mbps")
