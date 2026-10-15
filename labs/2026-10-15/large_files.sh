#!/usr/bin/env bash
set -Eeuo pipefail
if (( $# < 1 || $# > 2 )); then
  echo "Usage: $0 DIRECTORY [MIN_SIZE_MB]" >&2
  exit 2
fi
root=$1
minimum=${2:-100}
[[ -d "$root" ]] || { printf 'Not a directory: %s\n' "$root" >&2; exit 1; }
[[ "$minimum" =~ ^[0-9]+$ ]] || { echo "MIN_SIZE_MB must be an integer" >&2; exit 2; }
find "$root" -type f -size +"$((minimum))"M -printf '%s bytes\t%p\n' 2>/dev/null |
  sort -nr | head -n 50
