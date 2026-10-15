#!/usr/bin/env bash
set -u

usage() {
    printf 'Usage: %s DIRECTORY\n' "$0" >&2
}

if [[ $# -ne 1 ]]; then
    usage
    exit 2
fi

target=$1
if [[ ! -d "$target" ]]; then
    printf 'Error: not a directory: %s\n' "$target" >&2
    exit 1
fi

printf 'Disk usage for: %s\n\n' "$target"
if ! df -h "$target"; then
    printf 'Warning: df could not inspect the filesystem.\n' >&2
fi

printf '\nTotal directory size:\n'
if ! du -sh "$target"; then
    printf 'Warning: some directory entries could not be read.\n' >&2
fi

printf '\nLargest files (up to 10):\n'
find "$target" -type f -printf '%s\t%p\n' 2>/dev/null |
    sort -nr |
    head -n 10 |
    awk -F '\t' '{ printf "%10.2f MiB  %s\n", $1 / 1048576, $2 }'

printf '\nAudit complete. No files were changed.\n'
