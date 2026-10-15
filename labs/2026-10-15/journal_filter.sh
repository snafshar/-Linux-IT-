#!/usr/bin/env bash
set -Eeuo pipefail
unit=${1:-}
since=${2:-"1 hour ago"}
if [[ -z "$unit" ]]; then
  echo "Usage: $0 UNIT [SINCE]" >&2
  echo 'Example: ./journal_filter.sh ssh.service "today"' >&2
  exit 2
fi
if ! command -v journalctl >/dev/null 2>&1; then
  echo "journalctl is not installed" >&2
  exit 1
fi
journalctl --unit="$unit" --since="$since" --no-pager --output=short-iso
