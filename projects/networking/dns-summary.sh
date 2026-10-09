#!/usr/bin/env bash
set -euo pipefail
if command -v resolvectl >/dev/null 2>&1; then
    resolvectl status
elif [[ -f /etc/resolv.conf ]]; then
    cat /etc/resolv.conf
else
    echo "No DNS configuration source found." >&2
    exit 1
fi
