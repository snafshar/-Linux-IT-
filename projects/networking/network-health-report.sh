#!/usr/bin/env bash
set -euo pipefail

echo "=== Network Health Report ==="
echo
echo "Interfaces:"
ip -brief link
echo
echo "Addresses:"
ip -brief address
echo
echo "Routes:"
ip route
echo
echo "DNS:"
if command -v resolvectl >/dev/null 2>&1; then
    resolvectl status | sed -n '1,35p'
elif [[ -r /etc/resolv.conf ]]; then
    grep -E '^nameserver ' /etc/resolv.conf || true
fi
