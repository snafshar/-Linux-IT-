#!/usr/bin/env bash

set -uo pipefail

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  -w, --watch SECONDS   Refresh continuously every SECONDS
  -j, --json            Print a compact JSON summary
  -h, --help            Show this help message
EOF
}

log_error() { printf "Error: %s\n" "$*" >&2; }

WATCH=0
JSON=0

while [[ $# -gt 0 ]]; do
    case "$1" in
        -w|--watch)
            [[ $# -ge 2 ]] || { log_error "--watch requires seconds"; exit 2; }
            [[ "$2" =~ ^[1-9][0-9]*$ ]] || { log_error "watch interval must be a positive integer"; exit 2; }
            WATCH="$2"; shift 2 ;;
        -j|--json) JSON=1; shift ;;
        -h|--help) usage; exit 0 ;;
        *) log_error "unknown option: $1"; usage; exit 2 ;;
    esac
done

get_mem_percent() {
    if command -v free >/dev/null 2>&1; then
        free | awk '/Mem:/ {printf "%.1f", ($3/$2)*100}'
    else printf "unknown"; fi
}

get_root_disk_percent() {
    df -P / 2>/dev/null | awk 'NR==2 {gsub(/%/,"",$5); print $5}'
}

show_report() {
    local host kernel uptime_now cores load mem_pct disk_pct
    host="$(hostname 2>/dev/null || printf unknown)"
    kernel="$(uname -sr 2>/dev/null || printf unknown)"
    uptime_now="$(uptime -p 2>/dev/null || uptime 2>/dev/null || printf unknown)"
    cores="$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || printf unknown)"
    load="$(awk '{print $1, $2, $3}' /proc/loadavg 2>/dev/null || printf unknown)"
    mem_pct="$(get_mem_percent)"
    disk_pct="$(get_root_disk_percent)"

    if [[ "$JSON" -eq 1 ]]; then
        printf '{"host":"%s","kernel":"%s","uptime":"%s","cpu_cores":"%s","load":"%s","memory_used_percent":"%s","root_disk_used_percent":"%s"}\n' "$host" "$kernel" "$uptime_now" "$cores" "$load" "$mem_pct" "$disk_pct"
        return
    fi

    printf "========================================\n"
    printf "          Linux System Monitor           \n"
    printf "========================================\n"
    printf "Host              : %s\n" "$host"
    printf "Kernel            : %s\n" "$kernel"
    printf "Uptime            : %s\n" "$uptime_now"
    printf "CPU cores         : %s\n" "$cores"
    printf "Load average      : %s\n" "$load"
    printf "Memory used       : %s%%\n" "$mem_pct"
    printf "Root disk used    : %s%%\n" "$disk_pct"
    printf "Checked at        : %s\n" "$(date)"
    printf "\n--- Memory ---\n"
    if command -v free >/dev/null 2>&1; then free -h; else printf "free command is not available.\n"; fi
    printf "\n--- Disk ---\n"
    df -h / 2>/dev/null || printf "Unable to read root filesystem usage.\n"
    printf "\n--- Top CPU processes ---\n"
    if command -v ps >/dev/null 2>&1; then ps -eo pid,comm,%cpu,%mem --sort=-%cpu 2>/dev/null | head -n 8; else printf "ps command is not available.\n"; fi
    printf "\n--- Health flags ---\n"
    if [[ "$disk_pct" =~ ^[0-9]+$ ]] && (( disk_pct >= 70 )); then printf "WARNING: root disk usage is at or above 70%%.\n"; else printf "Root disk usage: OK\n"; fi
    printf "System check completed.\n"
}

command -v awk >/dev/null 2>&1 || { log_error "required command not found: awk"; exit 1; }

if (( WATCH > 0 )); then
    trap 'printf "\nStopped.\n"; exit 0' INT TERM
    while true; do
        clear 2>/dev/null || true
        show_report
        sleep "$WATCH"
    done
else
    show_report
fi