#!/usr/bin/env bash
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v mn >/dev/null 2>&1; then echo "Mininet is not installed or mn is not in PATH." >&2; exit 1; fi
if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then echo "Usage: $0 [--test]"; exit 0; fi
exec sudo python3 "$ROOT/campus_lab.py" "${1:-}"