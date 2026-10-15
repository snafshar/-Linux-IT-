# Shell Script Review Checklist

- [ ] Start with a clear shebang such as `#!/usr/bin/env bash`.
- [ ] Use `set -Eeuo pipefail` where its semantics are appropriate.
- [ ] Quote variable expansions: `"$path"`.
- [ ] Validate arguments and explain usage on stderr.
- [ ] Check files and directories before operating on them.
- [ ] Avoid destructive defaults; do not overwrite without explicit intent.
- [ ] Prefer arrays over building commands as strings.
- [ ] Use `mktemp` for temporary files and clean them with a trap.
- [ ] Send diagnostics to stderr and machine-readable output to stdout.
- [ ] Handle filenames containing spaces.
- [ ] Avoid parsing `ls`; use globs, `find -print0`, or `read -r`.
- [ ] Test success paths, missing inputs, empty inputs, and permission errors.
- [ ] Run ShellCheck when available: `shellcheck script.sh`.
- [ ] Document assumptions and give a harmless example invocation.
