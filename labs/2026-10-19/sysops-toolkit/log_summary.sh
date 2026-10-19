#!/usr/bin/env bash
set -u
if [[ $# -ne 1 || ! -f "$1" || ! -r "$1" ]]; then
  printf 'Usage: %s readable-log-file\n' "$0" >&2
  exit 2
fi
file=$1
printf 'Log summary: %s\n' "$file"
printf 'Lines: '
wc -l < "$file"
for word in ERROR WARN WARNING INFO DEBUG; do
  count=$(grep -Eic "$word" "$file" || true)
  printf '%-8s %s\n' "$word" "$count"
done
