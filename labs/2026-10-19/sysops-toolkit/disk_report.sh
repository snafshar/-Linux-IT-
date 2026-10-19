#!/usr/bin/env bash
set -u
if ! command -v df >/dev/null 2>&1; then
  printf 'Error: df is unavailable.\n' >&2
  exit 1
fi
printf 'Filesystem usage (human-readable)\n'
df -h -x tmpfs -x devtmpfs 2>/dev/null || df -h
