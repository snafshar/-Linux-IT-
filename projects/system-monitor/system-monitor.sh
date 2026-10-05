#!/usr/bin/env bash

set -u

echo "======================================"
echo "        Linux System Monitor"
echo "======================================"
echo
echo "Host      : $(hostname)"
echo "Kernel    : $(uname -sr)"
echo "Uptime    : $(uptime -p 2>/dev/null || uptime)"
echo "Date      : $(date)"
echo

echo "--- CPU / Load ---"
command -v nproc >/dev/null 2>&1 && echo "CPU cores : $(nproc)"
[ -r /proc/loadavg ] && echo "Load avg  : $(awk '{print $1, $2, $3}' /proc/loadavg)"
echo

echo "--- Memory ---"
command -v free >/dev/null 2>&1 && free -h || echo "free command is not available."
echo

echo "--- Disk ---"
df -h --output=target,size,used,avail,pcent 2>/dev/null || df -h
echo

echo "--- Logged-in users ---"
who 2>/dev/null || echo "Unable to read login information."
echo

echo "--- Top CPU processes ---"
ps -eo pid,comm,%cpu,%mem --sort=-%cpu 2>/dev/null | head -n 6 || echo "ps is not available."
echo
echo "System check completed."
