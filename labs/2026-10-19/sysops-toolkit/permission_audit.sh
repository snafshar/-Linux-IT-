#!/usr/bin/env bash
set -u
if [[ $# -ne 1 || ! -d "$1" || ! -r "$1" ]]; then
  printf 'Usage: %s readable-directory\n' "$0" >&2
  exit 2
fi
printf 'World-writable files under: %s\n' "$1"
find "$1" -type f -perm -0002 -print 2>/dev/null
printf 'Review each result before changing permissions; some shared locations intentionally allow writes.\n'
