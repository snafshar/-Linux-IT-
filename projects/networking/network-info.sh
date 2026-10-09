#!/usr/bin/env bash
set -euo pipefail
usage(){ echo "Usage: $0 [-i interface] [-j]"; }
interface=""; json=false
while [[ $# -gt 0 ]]; do
 case "$1" in
  -i|--interface) [[ $# -ge 2 ]] || exit 2; interface="$2"; shift 2;;
  -j|--json) json=true; shift;; -h|--help) usage; exit 0;;
  *) echo "Unknown option: $1" >&2; exit 2;;
 esac
done
command -v ip >/dev/null || { echo "ip command is required" >&2; exit 1; }
command -v ss >/dev/null || { echo "ss command is required" >&2; exit 1; }
[[ -z "$interface" ]] || ip link show "$interface" >/dev/null 2>&1 || { echo "Interface not found" >&2; exit 1; }
if $json; then
 if [[ -n "$interface" ]]; then addresses="$(ip -j addr show "$interface")"; else addresses="$(ip -j addr show)"; fi
 routes="$(ip -j route)"
 printf '{"hostname":"%s","interface":"%s","addresses":%s,"routes":%s}\n' "$(hostname)" "$interface" "$addresses" "$routes"
 exit 0
fi
echo "=== Network Information ==="; echo "Host: $(hostname)"
echo "--- Interfaces ---"; if [[ -n "$interface" ]]; then ip -br addr show "$interface"; else ip -br addr; fi
echo "--- Routes ---"; ip route
echo "--- Listening sockets ---"; ss -lntup 2>/dev/null || ss -lnt
echo "--- DNS ---"
if command -v resolvectl >/dev/null 2>&1; then resolvectl status | grep -E "DNS Servers|Current DNS Server" || true
else grep -E '^nameserver' /etc/resolv.conf || true; fi