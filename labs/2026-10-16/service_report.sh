#!/usr/bin/env bash
set -Eeuo pipefail
command -v systemctl >/dev/null 2>&1 || { echo "systemctl unavailable" >&2; exit 1; }
systemctl --failed --no-pager --plain
