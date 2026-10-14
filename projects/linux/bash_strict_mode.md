# Defensive Bash script patterns

For small scripts, consider:

```bash
#!/usr/bin/env bash
set -euo pipefail
```

- `-e` exits on many unhandled command failures.
- `-u` treats unset variables as errors.
- `pipefail` propagates a failure from a pipeline component.

These options are not a substitute for deliberate error handling. Commands used in
conditionals and some compound contexts behave differently. Quote variable
expansions such as `"$path"`, validate argument counts, and send diagnostics to
standard error. Test scripts with missing files and unusual filenames.
