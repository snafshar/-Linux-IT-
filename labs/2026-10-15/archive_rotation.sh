#!/usr/bin/env bash
set -Eeuo pipefail
if (( $# != 3 )); then
  echo "Usage: $0 SOURCE_DIR BACKUP_DIR KEEP_COUNT" >&2
  exit 2
fi
src=$1; dest=$2; keep=$3
[[ -d "$src" ]] || { echo "Source directory not found" >&2; exit 1; }
[[ "$keep" =~ ^[1-9][0-9]*$ ]] || { echo "KEEP_COUNT must be positive" >&2; exit 2; }
mkdir -p -- "$dest"
stamp=$(date +%Y%m%d-%H%M%S)
archive="$dest/backup-$stamp.tar.gz"
tar -czf "$archive" -C "$(dirname "$src")" "$(basename "$src")"
mapfile -t old < <(find "$dest" -maxdepth 1 -type f -name 'backup-*.tar.gz' -printf '%T@ %p\n' | sort -nr | awk "NR>$keep {sub(/^[^ ]+ /, \"\"); print}")
for item in "${old[@]}"; do
  [[ -n "$item" ]] && rm -- "$item"
done
printf 'Created %s; retained at most %s archives.\n' "$archive" "$keep"
