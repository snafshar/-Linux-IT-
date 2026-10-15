#!/usr/bin/env bash
set -Eeuo pipefail

threshold="${1:-80}"
if ! [[ "$threshold" =~ ^[0-9]+$ ]] || (( threshold < 1 || threshold > 100 )); then
  echo "Usage: $0 [threshold_percent: 1-100]" >&2
  exit 2
fi

printf 'Filesystem usage (warning threshold: %s%%)\n' "$threshold"
df -P -x tmpfs -x devtmpfs | awk -v threshold="$threshold" '
NR == 1 { print; next }
{
  usage = $5
  gsub(/%/, "", usage)
  print
  if (usage + 0 >= threshold) {
    printf "WARNING: %s is at %s%% usage\n", $6, usage > "/dev/stderr"
  }
}'
