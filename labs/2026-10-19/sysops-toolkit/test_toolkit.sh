#!/usr/bin/env bash
set -euo pipefail
here="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for script in "$here"/*.sh; do
  bash -n "$script"
done
if bash "$here/log_summary.sh" >/dev/null 2>&1; then
  echo "log_summary.sh should reject missing arguments" >&2
  exit 1
fi
if bash "$here/checksum_manifest.sh" >/dev/null 2>&1; then
  echo "checksum_manifest.sh should reject missing arguments" >&2
  exit 1
fi
if bash "$here/backup_preview.sh" >/dev/null 2>&1; then
  echo "backup_preview.sh should reject missing arguments" >&2
  exit 1
fi
echo "SysOps Toolkit syntax and usage tests passed."
