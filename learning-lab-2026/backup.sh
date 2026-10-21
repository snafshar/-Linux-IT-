#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: $0 SOURCE_DIR DEST_DIR" >&2
  exit 2
fi
source_dir=$1
dest_dir=$2
[[ -d "$source_dir" ]] || { echo "Source directory not found" >&2; exit 1; }
mkdir -p "$dest_dir"
archive="$dest_dir/backup-$(date +%Y%m%d-%H%M%S).tar.gz"
tar -czf "$archive" -C "$(dirname "$source_dir")" "$(basename "$source_dir")"
echo "Created $archive"