#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="${1:-/var/log/syslog}"
if [[ ! -r "$LOG_FILE" ]]; then
  echo "Cannot read log file: $LOG_FILE" >&2
  echo "Try a readable log path or run with appropriate permissions." >&2
  exit 1
fi

printf 'Recent lines from %s\n' "$LOG_FILE"
tail -n 50 -- "$LOG_FILE"
