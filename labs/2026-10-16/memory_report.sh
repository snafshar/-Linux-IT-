#!/usr/bin/env bash
set -Eeuo pipefail
if command -v free >/dev/null 2>&1; then
  free -h
else
  echo "The free command is unavailable on this system." >&2
  exit 1
fi
if [[ -r /proc/meminfo ]]; then
  printf '\nSelected /proc/meminfo fields:\n'
  grep -E '^(MemTotal|MemAvailable|SwapTotal|SwapFree):' /proc/meminfo
fi
