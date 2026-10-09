#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
command -v mn >/dev/null || { echo "Mininet is required" >&2; exit 1; }
sudo mn -c >/dev/null 2>&1 || true
exec sudo python3 "$ROOT/campus_lab.py" "$@"
