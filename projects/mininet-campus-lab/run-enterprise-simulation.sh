#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")" && pwd)"
command -v mn >/dev/null || { echo "Mininet required" >&2; exit 1; }
command -v ryu-manager >/dev/null || { echo "Ryu required" >&2; exit 1; }
sudo mn -c >/dev/null 2>&1 || true
LOG_FILE="/tmp/mininet-enterprise-ryu.log"
sudo ryu-manager --ofp-tcp-listen-port 6653 "$ROOT/enterprise_controller.py" >"$LOG_FILE" 2>&1 &
PID=$!
cleanup(){ kill "$PID" 2>/dev/null || true; sudo mn -c >/dev/null 2>&1 || true; }
trap cleanup EXIT INT TERM
sleep 2
sudo python3 "$ROOT/enterprise_simulation.py" --controller 127.0.0.1 --port 6653 --test --flows 100 --seed 42
