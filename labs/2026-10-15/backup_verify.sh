#!/usr/bin/env bash
set -Eeuo pipefail

if (( $# != 2 )); then
  echo "Usage: $0 SOURCE_DIRECTORY OUTPUT_ARCHIVE.tar.gz" >&2
  exit 2
fi

source_dir=$1
archive=$2
if [[ ! -d "$source_dir" ]]; then
  printf 'Not a directory: %s\n' "$source_dir" >&2
  exit 1
fi
if [[ -e "$archive" ]]; then
  printf 'Refusing to overwrite existing archive: %s\n' "$archive" >&2
  exit 1
fi

tar -czf "$archive" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
if tar -tzf "$archive" >/dev/null; then
  printf 'Archive created and verified: %s\n' "$archive"
else
  printf 'Archive verification failed: %s\n' "$archive" >&2
  exit 1
fi
