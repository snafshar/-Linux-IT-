#!/usr/bin/env bash
set -u
if ! command -v ps >/dev/null 2>&1; then
  printf 'Error: ps is unavailable.\n' >&2
  exit 1
fi
printf 'Top processes by CPU usage\n'
ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11
printf '\nTop processes by memory usage\n'
ps -eo pid,comm,%cpu,%mem --sort=-%mem | head -n 11
