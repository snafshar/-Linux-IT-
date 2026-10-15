#!/usr/bin/env bash
set -Eeuo pipefail
printf 'Host: %s\n' "$(hostname)"
printf 'Date: %s\n' "$(date -Is)"
printf 'Kernel: %s\n' "$(uname -sr)"
printf 'Architecture: %s\n' "$(uname -m)"
printf 'User: %s\n' "$(id -un)"
printf 'Uptime: '; uptime -p 2>/dev/null || uptime
printf '\nDisk usage:\n'; df -h -x tmpfs -x devtmpfs
