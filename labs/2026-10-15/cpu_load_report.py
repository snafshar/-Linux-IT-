#!/usr/bin/env python3
"""Report load averages and CPU count using the standard library."""
import os
import platform


def main() -> None:
    print(f"Host: {platform.node()}")
    print(f"Platform: {platform.platform()}")
    print(f"Logical CPUs: {os.cpu_count() or 'unknown'}")
    try:
        one, five, fifteen = os.getloadavg()
    except (AttributeError, OSError):
        print("Load averages: unavailable on this platform")
    else:
        print(f"Load average (1/5/15 min): {one:.2f} / {five:.2f} / {fifteen:.2f}")


if __name__ == "__main__":
    main()
