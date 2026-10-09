#!/usr/bin/env bash
set -euo pipefail

HOST="example.com"
COUNT=1
TIMEOUT=3
usage() { echo "Usage: $0 [-c count] [-t timeout] [host]"; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    -c|--count) COUNT="$2"; shift 2 ;;
    -t|--timeout) TIMEOUT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    -*) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
    *) HOST="$1"; shift ;;
  esac
done

[[ "$COUNT" =~ ^[1-9][0-9]*$ && "$TIMEOUT" =~ ^[1-9][0-9]*$ ]] || { echo "count and timeout must be positive integers" >&2; exit 2; }
command -v ip >/dev/null || { echo "ip command is required" >&2; exit 1; }
command -v ping >/dev/null || { echo "ping command is required" >&2; exit 1; }

echo "=== Connectivity Check ==="
echo "Target: $HOST"
echo
echo "[1/4] Default route"
ip route show default || true
echo
echo "[2/4] DNS"
if getent hosts "$HOST" >/dev/null; then echo "DNS: OK"; else echo "DNS: FAILED"; fi
echo
echo "[3/4] Target ping"
if ping -c "$COUNT" -W "$TIMEOUT" "$HOST"; then echo "Ping: OK"; else echo "Ping: FAILED"; fi
echo
echo "[4/4] Listening sockets"
ss -lnt 2>/dev/null || true