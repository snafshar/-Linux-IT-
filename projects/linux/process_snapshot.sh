#!/usr/bin/env bash
set -euo pipefail

# Print a stable, readable snapshot of the busiest local processes.
printf '%-8s %-8s %-8s %s\n' PID CPU MEM COMMAND
ps -eo pid=,pcpu=,pmem=,comm= --sort=-pcpu | head -n 11 |
  awk '{printf "%-8s %-8s %-8s %s\n", $1, $2, $3, $4}'
