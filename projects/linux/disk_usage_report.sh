#!/usr/bin/env bash
set -euo pipefail

printf 'Filesystem usage summary\n'
df -h -x tmpfs -x devtmpfs
