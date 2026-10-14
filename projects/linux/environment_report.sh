#!/usr/bin/env bash
set -euo pipefail

printf 'Hostname: '; hostname
printf 'Kernel: '; uname -sr
printf 'Architecture: '; uname -m
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Working directory: %s\n' "$PWD"
printf 'PATH entries:\n'
tr ':' '\n' <<< "${PATH:-}"
