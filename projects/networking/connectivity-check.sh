#!/usr/bin/env bash

set -uo pipefail

usage() {
  cat <<EOF
Usage: $0 [HOST]

Check local network configuration, default gateway, DNS resolution, and Internet connectivity.
Default test host: example.com
EOF
}

HOST="${1:-example.com}"
[[ $# -le 1 ]] || { usage; exit 2; }

command -v ip >/dev/null 2>&1 || { echo "Error: ip command not found." >&2; exit 1; }
command -v getent >/dev/null 2>&1 || { echo "Error: getent command not found." >&2; exit 1; }

PASS=0
FAIL=0
check() {
  local label="$1"; shift
  printf "%-30s" "$label"
  if "$@" >/dev/null 2>&1; then echo "OK"; ((PASS+=1)); else echo "FAIL"; ((FAIL+=1)); fi
}

echo "========================================"
echo "       Linux Connectivity Check         "
echo "========================================"
echo
echo "Target host: $HOST"
echo
echo "--- Network checks ---"

check "Network interface available" bash -c 'ip link show up | grep -q "state UP"'
check "Default IPv4 route" bash -c 'ip route show default | grep -q .'
check "Gateway reachability" bash -c 'GW=$(ip route show default | awk "NR==1 {print \\$3}"); [[ -n "$GW" ]] && ping -c 1 -W 2 "$GW"'
check "DNS resolution" getent ahosts "$HOST"
check "Internet connectivity" bash -c 'getent ahosts "$1" >/dev/null 2>&1 && ping -c 1 -W 3 "$1"' _ "$HOST"

echo
echo "Results: $PASS passed, $FAIL failed."
if (( FAIL == 0 )); then
  echo "Network checks completed successfully."
  exit 0
else
  echo "One or more checks failed. Inspect the output with network-info.sh."
  exit 1
fi