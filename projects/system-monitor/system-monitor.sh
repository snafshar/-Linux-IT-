#!/usr/bin/env bash

set -uo pipefail

WATCH=0; JSON=0; DISK_WARN=70; MEM_WARN=80

usage(){ cat <<EOF
Usage: $0 [OPTIONS]
  -w, --watch SECONDS   Refresh continuously
  -j, --json            Output one JSON record
  --disk-warn PCT       Disk warning threshold (default: 70)
  --mem-warn PCT        Memory warning threshold (default: 80)
  -h, --help            Show help
EOF
}

err(){ printf "Error: %s\n" "$*" >&2; }
valid_pct(){ [[ "$1" =~ ^[0-9]+$ ]] && (( $1 >= 0 && $1 <= 100 )); }
while [[ $# -gt 0 ]]; do case "$1" in
  -w|--watch) [[ $# -gt 1 && "$2" =~ ^[1-9][0-9]*$ ]] || { err "invalid watch interval"; exit 2; }; WATCH="$2"; shift 2;;
  -j|--json) JSON=1; shift;;
  --disk-warn) [[ $# -gt 1 ]] && valid_pct "$2" || { err "disk threshold must be 0-100"; exit 2; }; DISK_WARN="$2"; shift 2;;
  --mem-warn) [[ $# -gt 1 ]] && valid_pct "$2" || { err "memory threshold must be 0-100"; exit 2; }; MEM_WARN="$2"; shift 2;;
  -h|--help) usage; exit 0;;
  *) err "unknown option: $1"; usage; exit 2;;
esac; done

mem_pct(){ free 2>/dev/null | awk '/Mem:/ {if($2>0) printf "%.1f",($3/$2)*100; else print "unknown"}'; }
disk_pct(){ df -P / 2>/dev/null | awk 'NR==2 {gsub(/%/,"",$5); print $5}'; }
load_data(){ awk '{print $1" "$2" "$3}' /proc/loadavg 2>/dev/null || printf unknown; }

report(){
 local host kernel up cores load mem disk status
 host="$(hostname 2>/dev/null || printf unknown)"; kernel="$(uname -sr 2>/dev/null || printf unknown)"
 up="$(uptime -p 2>/dev/null || uptime 2>/dev/null || printf unknown)"
 cores="$(nproc 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null || printf unknown)"
 load="$(load_data)"; mem="$(mem_pct)"; disk="$(disk_pct)"
 status="OK"
 if [[ "$disk" =~ ^[0-9]+$ ]] && (( disk >= DISK_WARN )); then status="WARNING"; fi
 if [[ "$mem" =~ ^[0-9]+ ]] && (( ${mem%.*} >= MEM_WARN )); then status="WARNING"; fi
 if (( JSON )); then
   printf '{"host":"%s","kernel":"%s","uptime":"%s","cpu_cores":"%s","load":"%s","memory_used_percent":"%s","root_disk_used_percent":"%s","status":"%s"}\n' "$host" "$kernel" "$up" "$cores" "$load" "$mem" "$disk" "$status"
   return
 fi
 printf "\n=== Linux System Monitor ===\nHost: %s\nKernel: %s\nUptime: %s\nCPU cores: %s\nLoad: %s\nMemory used: %s%%\nRoot disk: %s%%\nStatus: %s\n" "$host" "$kernel" "$up" "$cores" "$load" "$mem" "$disk" "$status"
 printf "\n--- Memory ---\n"; free -h 2>/dev/null || true
 printf "\n--- Disk ---\n"; df -h / 2>/dev/null || true
 printf "\n--- Top CPU processes ---\n"; ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu 2>/dev/null | head -n 8 || true
 if [[ "$status" == WARNING ]]; then printf "\nReview the configured resource thresholds.\n"; fi
}

command -v awk >/dev/null 2>&1 || { err "awk is required"; exit 1; }
if (( WATCH )); then trap 'printf "\nStopped.\n"; exit 0' INT TERM; while :; do clear 2>/dev/null || true; report; sleep "$WATCH"; done; else report; fi