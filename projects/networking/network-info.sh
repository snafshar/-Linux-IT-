#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 [-i interface] [-j] [-h]"
  echo "  -i, --interface NAME  Inspect one interface"
  echo "  -j, --json             Emit JSON"
}

interface=""
json=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -i|--interface) [[ $# -ge 2 ]] || { echo "Missing interface name" >&2; exit 2; }; interface="$2"; shift 2 ;;
    -j|--json) json=true; shift ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

command -v ip >/dev/null || { echo "ip command is required" >&2; exit 1; }
if [[ -n "$interface" ]] && ! ip link show "$interface" >/dev/null 2>&1; then
  echo "Interface not found: $interface" >&2; exit 1
fi

if $json; then
  printf "{\"hostname\":\"%s\",\"interface\":\"%s\",\"addresses\":" "$(hostname)" "$interface"
  ip -j addr show ${interface:+"$interface"}
  printf ",\"routes\":"
  ip -j route
  printf "}\n"
  exit 0
fi

echo "=== Network Information ==="
echo "Host: $(hostname)"
echo
echo "--- Interfaces ---"
ip -br addr ${interface:+"$interface"}
echo
echo "--- Routes ---"
ip route
echo
echo "--- Listening sockets ---"
ss -lntup 2>/dev/null || ss -lnt
echo
echo "--- DNS ---"
if command -v resolvectl >/dev/null 2>&1; then
  resolvectl status | grep -E "DNS Servers|Current DNS Server" || true
else
  grep -E "^nameserver" /etc/resolv.conf || true
fi