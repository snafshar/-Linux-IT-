#!/usr/bin/env bash
set -u
if [[ $# -lt 1 ]]; then
  printf 'Usage: %s file [file ...]\n' "$0" >&2
  exit 2
fi
if ! command -v sha256sum >/dev/null 2>&1; then
  printf 'Error: sha256sum is unavailable on this system.\n' >&2
  exit 1
fi
status=0
for file in "$@"; do
  if [[ -f "$file" && -r "$file" ]]; then
    sha256sum -- "$file" || status=1
  else
    printf 'Skipping unreadable or missing file: %s\n' "$file" >&2
    status=1
  fi
done
exit "$status"
