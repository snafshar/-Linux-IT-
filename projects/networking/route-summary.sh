#!/usr/bin/env bash
set -euo pipefail
command -v ip >/dev/null 2>&1 || { echo "Error: ip command is required." >&2; exit 1; }
echo "=== Routing table ==="
ip route
echo
echo "=== Default route ==="
ip route show default
