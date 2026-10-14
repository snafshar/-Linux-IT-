#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 DIRECTORY OUTPUT.tar.gz" >&2
  exit 2
fi
source_dir=$1
archive=$2

if [[ ! -d "$source_dir" ]]; then
  echo "Not a directory: $source_dir" >&2
  exit 1
fi
if [[ -e "$archive" ]]; then
  echo "Refusing to overwrite existing archive: $archive" >&2
  exit 1
fi

tar -czf "$archive" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
printf 'Created %s\n' "$archive"
