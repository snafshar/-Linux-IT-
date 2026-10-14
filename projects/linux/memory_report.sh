#!/usr/bin/env bash
set -euo pipefail

if command -v free >/dev/null 2>&1; then
  free -h
elif [[ -r /proc/meminfo ]]; then
  grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo
else
  echo "Memory information is unavailable on this system." >&2
  exit 1
fi
