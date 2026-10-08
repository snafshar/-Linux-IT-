#!/usr/bin/env bash
set -uo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! command -v mn >/dev/null 2>&1; then echo 'Mininet is required.' >&2; exit 1; fi
if ! command -v ryu-manager >/dev/null 2>&1; then echo 'Ryu is required. Install it before using SDN mode.' >&2; exit 1; fi
echo 'Starting Ryu OpenFlow 1.3 learning-switch controller...'
sudo ryu-manager --ofp-tcp-listen-port 6653 "$ROOT/ryu_controller.py" >/tmp/mininet-ryu.log 2>&1 &
CTRL_PID=$!
trap 'sudo mn -c >/dev/null 2>&1 || true; kill $CTRL_PID 2>/dev/null || true' EXIT INT TERM
sleep 2
sudo python3 "$ROOT/sdn_namespace_lab.py" --controller 127.0.0.1 --port 6653 --test