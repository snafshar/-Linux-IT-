#!/usr/bin/env bash
set -u

target="${1:-example.com}"

printf 'NetCheck — Linux network diagnostics\n'
printf 'Target: %s\n\n' "$target"

if command -v hostname >/dev/null 2>&1; then
  printf 'Hostname: '
  hostname
fi

if command -v ip >/dev/null 2>&1; then
  printf '\nDefault route:\n'
  ip route show default 2>/dev/null || printf 'No default route found.\n'
else
  printf '\nRoute check skipped (ip command unavailable).\n'
fi

printf '\nDNS lookup:\n'
if command -v getent >/dev/null 2>&1 && getent hosts "$target"; then
  :
else
  printf 'Could not resolve %s with getent.\n' "$target"
fi

printf '\nConnectivity check:\n'
if command -v ping >/dev/null 2>&1; then
  if ping -c 1 -W 2 "$target" >/dev/null 2>&1; then
    printf 'Ping succeeded.\n'
  else
    printf 'Ping failed or was blocked; this does not necessarily mean the host is down.\n'
  fi
else
  printf 'Ping check skipped (ping command unavailable).\n'
fi
