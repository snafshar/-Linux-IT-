#!/usr/bin/env bash
set -euo pipefail

path=${1:-.}
if [[ ! -e "$path" ]]; then
  echo "Path does not exist: $path" >&2
  exit 1
fi
printf 'Path: %s\n' "$path"
ls -ld -- "$path"
stat -c 'owner=%U group=%G mode=%A (%a)' -- "$path"
if [[ -r "$path" ]]; then echo 'Readable: yes'; else echo 'Readable: no'; fi
if [[ -w "$path" ]]; then echo 'Writable: yes'; else echo 'Writable: no'; fi