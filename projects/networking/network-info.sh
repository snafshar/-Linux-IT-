#!/usr/bin/env bash
set -uo pipefail

JSON=0; INTERFACE=""
usage(){ cat <<EOF
Usage: $0 [OPTIONS]
  -i, --interface NAME   Inspect one interface
  -j, --json             Compact machine-readable summary
  -h, --help             Show help
EOF
}
while [[ $# -gt 0 ]]; do case "$1" in
 -i|--interface) [[ $# -gt 1 ]] || { echo "Missing interface name" >&2; exit 2; }; INTERFACE="$2"; shift 2;;
 -j|--json) JSON=1; shift;; -h|--help) usage; exit 0;; *) echo "Unknown option: $1" >&2; usage; exit 2;; esac; done
command -v ip >/dev/null 2>&1 || { echo "Error: iproute2 is required." >&2; exit 1; }
if [[ -n "$INTERFACE" ]] && ! ip link show "$INTERFACE" >/dev/null 2>&1; then echo "Error: interface not found: $INTERFACE" >&2; exit 1; fi
if (( JSON )); then
  IFACE="$INTERFACE"; [[ -n "$IFACE" ]] || IFACE="$(ip -o link show | awk -F": " 'NR==1{print $2}')"
  ADDR="$(ip -brief address show "$IFACE" 2>/dev/null | tr "\n" ";")"; ROUTE="$(ip route show default 2>/dev/null | head -n1)"
  printf '{"interface":"%s","addresses":"%s","default_route":"%s"}\n' "$IFACE" "$ADDR" "$ROUTE"
  exit 0
fi
echo "=== Linux Network Inspector ==="; echo
echo "--- Interfaces and addresses ---"; if [[ -n "$INTERFACE" ]]; then ip -details address show "$INTERFACE"; else ip -brief address; fi
echo; echo "--- IPv4 routes ---"; ip route show
echo; echo "--- IPv6 routes ---"; ip -6 route show
echo; echo "--- DNS ---"; if command -v resolvectl >/dev/null 2>&1; then resolvectl status 2>/dev/null | sed -n "1,100p"; elif [[ -r /etc/resolv.conf ]]; then cat /etc/resolv.conf; else echo "DNS configuration unavailable."; fi
echo; echo "--- Listening sockets ---"; if command -v ss >/dev/null 2>&1; then ss -tuln; else echo "ss not available."; fi