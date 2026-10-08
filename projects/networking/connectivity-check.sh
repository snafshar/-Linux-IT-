#!/usr/bin/env bash
set -uo pipefail

HOST="example.com"; COUNT=1; TIMEOUT=3
usage(){ cat <<EOF
Usage: $0 [OPTIONS] [HOST]
  -c, --count N       Ping attempts (default: 1)
  -t, --timeout SEC   Ping timeout (default: 3)
  -h, --help          Show help
EOF
}
while [[ $# -gt 0 ]]; do case "$1" in
 -c|--count) [[ $# -gt 1 && "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid count" >&2; exit 2; }; COUNT="$2"; shift 2;;
 -t|--timeout) [[ $# -gt 1 && "$2" =~ ^[1-9][0-9]*$ ]] || { echo "Invalid timeout" >&2; exit 2; }; TIMEOUT="$2"; shift 2;;
 -h|--help) usage; exit 0;; -*) echo "Unknown option: $1" >&2; exit 2;; *) [[ "$HOST" == example.com ]] || { echo "Only one host is allowed" >&2; exit 2; }; HOST="$1"; shift;; esac; done
command -v ip >/dev/null 2>&1 || { echo "iproute2 is required" >&2; exit 1; }
command -v getent >/dev/null 2>&1 || { echo "getent is required" >&2; exit 1; }
PASS=0; FAIL=0
check(){ local n="$1"; shift; printf "%-30s" "$n"; if "$@" >/dev/null 2>&1; then echo OK; ((PASS++)); else echo FAIL; ((FAIL++)); fi; }
echo "=== Linux Connectivity Diagnostic ==="; echo "Target: $HOST"; echo
check "Interface is up" bash -c 'ip -o link show up | grep -q "state UP"'
check "Default route exists" bash -c 'ip route show default | grep -q .'
check "DNS resolves target" getent ahosts "$HOST"
if command -v ping >/dev/null 2>&1; then check "Gateway responds" bash -c 'G=$(ip route show default | awk "NR==1{print $3}"); [[ -n "$G" ]] && ping -c "$1" -W "$2" "$G"' _ "$COUNT" "$TIMEOUT"; check "Target responds" ping -c "$COUNT" -W "$TIMEOUT" "$HOST"; else echo "ping not installed; ICMP checks skipped."; fi
echo; echo "Passed: $PASS"; echo "Failed: $FAIL"
(( FAIL == 0 )) && exit 0 || exit 1