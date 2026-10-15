#!/usr/bin/env python3
"""Resolve a hostname using the operating system resolver."""
import argparse
import socket

def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("hostname")
    args = parser.parse_args()
    try:
        results = sorted({item[4][0] for item in socket.getaddrinfo(args.hostname, None)})
    except socket.gaierror as exc:
        parser.error(f"resolution failed: {exc}")
    for address in results:
        print(address)
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
