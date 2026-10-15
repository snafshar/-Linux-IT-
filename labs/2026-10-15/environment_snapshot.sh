#!/usr/bin/env bash
set -Eeuo pipefail
printf 'Generated: %s\n' "$(date -Is)"
printf 'User: %s\n' "$(id -un)"
printf 'Host: %s\n' "$(hostname)"
printf 'Kernel: %s\n' "$(uname -srmo)"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Working directory: %s\n' "$PWD"
printf '\n-- Uptime --\n'
uptime
printf '\n-- Filesystem --\n'
df -h -x tmpfs -x devtmpfs
printf '\n-- Memory --\n'
if command -v free >/dev/null 2>&1; then free -h; else echo 'free command unavailable'; fi
