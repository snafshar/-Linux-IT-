#!/usr/bin/env bash
set -euo pipefail
command -v ss >/dev/null 2>&1 || { echo "Error: ss command is required." >&2; exit 1; }
echo "=== Listening TCP sockets ==="
ss -ltn
echo
echo "=== Listening UDP sockets ==="
ss -lun
