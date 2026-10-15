# Linux Troubleshooting Workflow

1. **Define the symptom.** Record exact error text, time, and recent changes.
2. **Check scope.** One process, one user, one host, or multiple hosts?
3. **Inspect state.** Use `uptime`, `free -h`, `df -h`, `ps`, and `systemctl status`.
4. **Check logs.** Use `journalctl --since` or the relevant application log.
5. **Isolate dependencies.** Check DNS, routes, sockets, storage, and permissions independently.
6. **Make one reversible change.** Avoid changing several variables at once.
7. **Verify the outcome.** Repeat the original check and observe side effects.
8. **Record the fix.** Include cause, evidence, commands, and rollback instructions.

Do not collect secrets, tokens, or private user data in diagnostic notes.
