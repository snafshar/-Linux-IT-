#!/usr/bin/env bash
set -u
if command -v ss >/dev/null 2>&1; then
  ss -lntup 2>/dev/null || ss -lnt
elif command -v netstat >/dev/null 2>&1; then
  netstat -lnt
else
  printf 'Neither ss nor netstat is installed.\n' >&2
  exit 1
fi
