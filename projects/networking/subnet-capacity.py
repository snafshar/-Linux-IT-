#!/usr/bin/env python3
"""Calculate IPv4 CIDR address capacity without external packages."""


def capacity(prefix: int) -> tuple[int, int]:
    if not 0 <= prefix <= 32:
        raise ValueError("prefix must be between 0 and 32")
    total = 2 ** (32 - prefix)
    usable = total - 2 if prefix <= 30 else total
    return total, usable


if __name__ == "__main__":
    prefix = int(input("IPv4 prefix length: "))
    total, usable = capacity(prefix)
    print(f"total addresses: {total}")
    print(f"usable hosts: {usable}")
