#!/usr/bin/env bash
set -Eeuo pipefail
if (( $# != 1 )); then echo "Usage: $0 FILE" >&2; exit 2; fi
[[ -f "$1" && -r "$1" ]] || { echo "Input must be a readable file" >&2; exit 1; }
printf 'Lines: '; wc -l < "$1"
printf 'Words: '; wc -w < "$1"
printf 'Bytes: '; wc -c < "$1"
