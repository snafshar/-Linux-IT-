#!/usr/bin/env python3
"""Calculate network throughput from bytes transferred and elapsed time."""

import argparse


def megabits_per_second(byte_count: int, seconds: float) -> float:
    if byte_count < 0:
        raise ValueError("byte count must not be negative")
    if seconds <= 0:
        raise ValueError("duration must be greater than zero")
    return byte_count * 8 / seconds / 1_000_000


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bytes", type=int, help="number of bytes transferred")
    parser.add_argument("seconds", type=float, help="transfer duration in seconds")
    args = parser.parse_args()
    try:
        rate = megabits_per_second(args.bytes, args.seconds)
    except ValueError as error:
        parser.error(str(error))
    print(f"Throughput: {rate:.2f} Mbps")


if __name__ == "__main__":
    main()
