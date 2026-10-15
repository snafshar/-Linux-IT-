# Bash Functions Lab

```bash
#!/usr/bin/env bash
set -Eeuo pipefail
usage() { echo "Usage: $0 NAME" >&2; }
greet() {
  local name=$1
  printf 'Hello, %s!\n' "$name"
}
if (( $# != 1 )); then usage; exit 2; fi
greet "$1"
```

Exercises: add a check for an empty argument, return a nonzero status for invalid input, and explain why local variables and quoted expansions help prevent bugs.
