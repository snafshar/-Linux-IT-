#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 SERVICE_NAME" >&2
  exit 2
fi
if ! command -v systemctl >/dev/null 2>&1; then
  echo "systemctl is not available on this system." >&2
  exit 1
fi

systemctl --no-pager --full status "$1"
