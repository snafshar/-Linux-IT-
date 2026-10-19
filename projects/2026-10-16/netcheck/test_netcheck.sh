#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
script="$project_dir/netcheck.sh"

bash -n "$script"

# Extra arguments must fail with a usage error.
if bash "$script" first second >/tmp/netcheck-extra.out 2>&1; then
  printf 'Expected extra arguments to be rejected.\n' >&2
  exit 1
else
  status=$?
  [[ $status -eq 2 ]] || { printf 'Expected exit 2 for extra arguments, got %s.\n' "$status" >&2; exit 1; }
fi

# Shell metacharacters and spaces are rejected rather than passed to tools.
if bash "$script" 'bad;target' >/tmp/netcheck-invalid.out 2>&1; then
  printf 'Expected invalid target to be rejected.\n' >&2
  exit 1
else
  status=$?
  [[ $status -eq 2 ]] || { printf 'Expected exit 2 for invalid target, got %s.\n' "$status" >&2; exit 1; }
fi

# Localhost is deterministic to resolve on CI and produces a complete report.
report="$(bash "$script" 127.0.0.1)"
grep -q 'NetCheck — Linux network diagnostics' <<<"$report"
grep -q 'Target: 127.0.0.1' <<<"$report"
grep -q 'Connectivity check:' <<<"$report"
grep -q 'does not change network settings' <<<"$report"

printf 'NetCheck smoke tests passed.\n'
