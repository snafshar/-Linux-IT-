#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
command -v mn >/dev/null || { echo 'Mininet required'; exit 1; }
command -v ryu-manager >/dev/null || { echo 'Ryu required'; exit 1; }
sudo mn -c >/dev/null 2>&1 || true
sudo ryu-manager --ofp-tcp-listen-port 6653 "$ROOT/enterprise_controller.py" >/tmp/mininet-enterprise-ryu.log 2>&1 &
PID=$!
trap 'kill $PID 2>/dev/null || true; sudo mn -c >/dev/null 2>&1 || true' EXIT
sleep 2
sudo python3 "$ROOT/enterprise_simulation.py" --controller 127.0.0.1 --port 6653 --test --flows 100
