#!/usr/bin/env bash
set -u

if (( $# > 1 )); then
  printf 'Usage: %s [hostname-or-ip]\n' "$0" >&2
  exit 2
fi

target="${1:-example.com}"
if [[ -z "$target" || "$target" == -* || "$target" == *[!a-zA-Z0-9.:-]* ]]; then
  printf 'Error: target must be a hostname or IP address (no leading dash or shell metacharacters).\n' >&2
  exit 2
fi

printf 'NetCheck — Linux network diagnostics\n'
printf 'Target: %s\n' "$target"
printf 'Time:   %s\n\n' "$(date '+%Y-%m-%d %H:%M:%S %Z' 2>/dev/null || printf 'unknown')"

if command -v hostname >/dev/null 2>&1; then
  printf 'Hostname: '
  hostname
fi

printf '\nDefault route:\n'
if command -v ip >/dev/null 2>&1; then
  route_output="$(ip route show default 2>/dev/null || true)"
  if [[ -n "$route_output" ]]; then
    printf '%s\n' "$route_output"
  else
    printf 'No default route found.\n'
  fi
else
  printf 'Skipped (ip command unavailable).\n'
fi

printf '\nDNS / address lookup:\n'
if command -v getent >/dev/null 2>&1; then
  if getent ahosts "$target" 2>/dev/null | awk '!seen[$1]++ { print; found=1 } END { exit !found }'; then
    :
  else
    printf 'No address returned by getent.\n'
  fi
else
  printf 'Skipped (getent command unavailable).\n'
fi

printf '\nConnectivity check:\n'
if command -v ping >/dev/null 2>&1; then
  if ping -c 1 -W 2 -- "$target" >/dev/null 2>&1; then
    printf 'Ping succeeded.\n'
  else
    printf 'Ping failed or was blocked; this does not necessarily mean the host is down.\n'
  fi
else
  printf 'Skipped (ping command unavailable).\n'
fi

printf '\nNote: checks are best-effort; this script does not change network settings.\n'
