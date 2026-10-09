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
[[ "$COUNT" =~ ^[1-9][0-9]*$ && "$TIMEOUT" =~ ^[1-9][0-9]*$ ]] || exit 2
for command in ip ping ss getent; do command -v "$command" >/dev/null || { echo "$command required" >&2; exit 1; }; done
echo "=== Connectivity Check ==="; echo "Target: $HOST"
echo "[1] Default route"; ip route show default || true
echo "[2] DNS"; getent hosts "$HOST" >/dev/null && echo "DNS: OK" || echo "DNS: FAILED"
echo "[3] Ping"; ping -c "$COUNT" -W "$TIMEOUT" "$HOST" && echo "Ping: OK" || echo "Ping: FAILED"
echo "[4] Listening sockets"; ss -lnt 2>/dev/null || true
echo "[5] Interfaces"; ip -br addr