# Linux Process States

Inspect processes with `ps -eo pid,ppid,state,comm --sort=pid`.

Common state codes:
- **R**: running or runnable.
- **S**: interruptible sleep.
- **D**: uninterruptible sleep, often waiting for I/O.
- **T**: stopped or traced.
- **Z**: zombie; the process has exited but has not yet been reaped by its parent.

Exercises:
1. Find your shell's PID with `echo $$`.
2. Compare `ps` output with `top`.
3. Explain why a zombie is not the same as a running process.
4. Do not kill processes you do not own or understand.
