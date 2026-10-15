#!/usr/bin/env bash
set -Eeuo pipefail

printf '%s\n' "== Process audit ==" "Host: $(hostname)" "Time: $(date -Is)" ""
printf '%s\n' "-- Highest CPU consumers --"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%cpu | head -n 11
printf '\n%s\n' "-- Highest memory consumers --"
ps -eo pid,ppid,comm,%cpu,%mem --sort=-%mem | head -n 11
printf '\n%s\n' "-- Process counts --"
printf 'Total processes: '
ps -e --no-headers | wc -l
printf 'Processes owned by current user: '
ps -u "$(id -un)" --no-headers | wc -l
