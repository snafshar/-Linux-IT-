# Disk Audit Exercises

1. Run the script on a directory containing spaces in its name.
2. Compare `df -h DIRECTORY` with `du -sh DIRECTORY`. Explain why their numbers differ.
3. Change the largest-file limit from 10 to 5.
4. Adapt the script to accept a second optional argument for the result count.
5. Explain why a read-only audit script should not automatically delete large files.

## Portability note

The `find -printf` option is available in GNU find, commonly installed on Linux. macOS users can replace that pipeline with a portable alternative such as `find ... -exec stat ...`, adjusting the `stat` syntax for the platform.
