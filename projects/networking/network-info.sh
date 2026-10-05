#!/usr/bin/env bash

set -uo pipefail

usage() {
  cat <<EOF
Usage: $0

Display Linux network interfaces, addresses, routes, DNS configuration, and listening sockets.
EOF
}

[[ $# -eq 0 ]] || { usage; exit 2; }

command -v ip >/dev/null 2>&1 || { echo "Error: ip command not found (install iproute2)." >&2; exit 1; }

echo "========================================"
echo "          Linux Network Info            "
echo "========================================"
echo
echo "--- Interfaces and addresses ---"
ip -brief address
echo
echo "--- Default and active routes ---"
ip route show
echo
echo "--- IPv6 routes ---"
ip -6 route show
echo
echo "--- DNS configuration ---"
if command -v resolvectl >/dev/null 2>&1; then
  resolvectl status 2>/dev/null | sed -n '1,80p'
elif [[ -r /etc/resolv.conf ]]; then
  cat /etc/resolv.conf
else
  echo "DNS configuration could not be read."
fi
echo
echo "--- Listening TCP/UDP sockets ---"
if command -v ss >/dev/null 2>&1; then
  ss -tuln
else
  echo "ss command not found (install iproute2)."
fi
echo
echo "Network inspection completed."