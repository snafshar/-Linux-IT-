#!/usr/bin/env bash
set -euo pipefail
command -v ip >/dev/null 2>&1 || { echo "Error: ip command is required." >&2; exit 1; }
echo "=== IPv4 addresses ==="
ip -4 -br addr
echo
echo "=== IPv6 addresses ==="
ip -6 -br addr
