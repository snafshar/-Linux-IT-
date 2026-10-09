#!/usr/bin/env bash
set -euo pipefail
HOST="example.com"; COUNT=1; TIMEOUT=3
while [[ $# -gt 0 ]]; do
 case "$1" in
  -c|--count) [[ $# -gt 1 ]] || exit 2; COUNT="$2"; shift 2;;
  -t|--timeout) [[ $# -gt 1 ]] || exit 2; TIMEOUT="$2"; shift 2;;
  -h|--help) echo "Usage: $0 [-c count] [-t timeout] [host]"; exit 0;;
  -*) echo "Unknown option: $1" >&2; exit 2;; *) HOST="$1"; shift;;
 esac
done
[[ "$COUNT" =~ ^[1-9][0-9]*$ && "$TIMEOUT" =~ ^[1-9][0-9]*$ ]] || { echo "count and timeout must be positive integers" >&2; exit 2; }
for command in ip ping ss getent; do command -v "$command" >/dev/null || { echo "$command required" >&2; exit 1; }; done
echo "=== Connectivity Check ==="; echo "Target: $HOST"
route_status=0; dns_status=0; ping_status=0
ip route show default >/dev/null 2>&1 || route_status=1
getent hosts "$HOST" >/dev/null 2>&1 || dns_status=1
ping -c "$COUNT" -W "$TIMEOUT" "$HOST" >/dev/null 2>&1 || ping_status=1
echo "Default route: $([[ $route_status -eq 0 ]] && echo OK || echo FAILED)"
echo "DNS: $([[ $dns_status -eq 0 ]] && echo OK || echo FAILED)"
echo "Ping: $([[ $ping_status -eq 0 ]] && echo OK || echo FAILED)"
echo "Listening sockets:"; ss -lnt 2>/dev/null || true
echo "Interfaces:"; ip -br addr
((route_status+dns_status+ping_status==0)) || exit 1
