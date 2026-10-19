#!/usr/bin/env bash
set -u
printf 'System information\n'
printf '==================\n'
printf 'Host: %s\n' "$(hostname 2>/dev/null || printf 'unknown')"
printf 'Kernel: %s\n' "$(uname -sr 2>/dev/null || printf 'unknown')"
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  printf 'OS: %s\n' "${PRETTY_NAME:-unknown}"
else
  printf 'OS: distribution metadata unavailable\n'
fi
if command -v uptime >/dev/null 2>&1; then
  printf 'Uptime: %s\n' "$(uptime -p 2>/dev/null || uptime)"
fi
printf 'Architecture: %s\n' "$(uname -m 2>/dev/null || printf 'unknown')"
