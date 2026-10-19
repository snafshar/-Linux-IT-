#!/usr/bin/env bash
set -u
printf 'User: %s\n' "${USER:-unknown}"
printf 'Shell: %s\n' "${SHELL:-unknown}"
printf 'Home: %s\n' "${HOME:-unknown}"
printf 'Path entries: %s\n' "$(printf '%s' "${PATH:-}" | tr ':' '\n' | wc -l | tr -d ' ')"
printf 'Locale: %s\n' "${LANG:-unknown}"
printf 'Note: environment variables may contain sensitive values; this report intentionally avoids dumping the full environment.\n'
