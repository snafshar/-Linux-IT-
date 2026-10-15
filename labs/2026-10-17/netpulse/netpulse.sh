#!/usr/bin/env bash
# NetPulse: read-only network diagnostics for Linux.
set -u

target="${1:-}"

section() { printf '\n== %s ==\n' "$1"; }

section "Host"
printf 'Hostname: '
hostname 2>/dev/null || printf 'unavailable\n'

section "Interfaces and addresses"
if command -v ip >/dev/null 2>&1; then
    ip -brief address show 2>/dev/null || ip address show 2>/dev/null || true
else
    printf 'The ip command is not installed.\n'
fi

section "Default route"
if command -v ip >/dev/null 2>&1; then
    ip route show default 2>/dev/null || true
else
    printf 'Cannot inspect routes without iproute2.\n'
fi

section "Name resolution"
if [[ -n "$target" ]]; then
    if command -v getent >/dev/null 2>&1; then
        if ! getent ahosts "$target"; then
            printf 'Resolution failed for %s\n' "$target"
        fi
    else
        printf 'getent is unavailable; skipped lookup for %s\n' "$target"
    fi
else
    printf 'Tip: pass a hostname to test name resolution, e.g. ./netpulse.sh example.com\n'
fi

section "Optional connectivity test"
if [[ -n "$target" ]] && command -v ping >/dev/null 2>&1; then
    if ping -c 1 -W 2 "$target" >/dev/null 2>&1; then
        printf 'ICMP reply received from %s\n' "$target"
    else
        printf 'No ICMP reply from %s (this alone does not prove the host is down).\n' "$target"
    fi
else
    printf 'Skipped. Supply a target and ensure ping is installed.\n'
fi

printf '\nDiagnostics complete. No network settings were changed.\n'
