#!/usr/bin/env bash

set -u

SOURCE="${1:-}"
DESTINATION="${2:-}"

if [ -z "$SOURCE" ] || [ -z "$DESTINATION" ]; then
    echo "Usage: $0 SOURCE_DIRECTORY BACKUP_DIRECTORY"
    exit 1
fi

if [ ! -d "$SOURCE" ]; then
    echo "Error: source directory does not exist: $SOURCE"
    exit 1
fi

mkdir -p "$DESTINATION" || {
    echo "Error: cannot create backup directory: $DESTINATION"
    exit 1
}

SOURCE_ABS="$(cd "$SOURCE" && pwd)"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
ARCHIVE="$DESTINATION/backup_${TIMESTAMP}.tar.gz"

tar -czf "$ARCHIVE" -C "$(dirname "$SOURCE_ABS")" "$(basename "$SOURCE_ABS")"

if [ $? -eq 0 ]; then
    echo "Backup created successfully:"
    echo "$ARCHIVE"
else
    echo "Backup failed."
    exit 1
fi
