# SSH Configuration Review Checklist

This is an audit checklist, not an automatic configuration changer.

- [ ] Confirm the server and administrator are authorized for review.
- [ ] Inspect effective settings with `sshd -T` where permitted.
- [ ] Prefer key-based authentication where operationally appropriate.
- [ ] Disable root login only after confirming an alternative admin path.
- [ ] Review `AllowUsers`, `AllowGroups`, and authentication policy.
- [ ] Keep the SSH service reachable from a second session before reloading.
- [ ] Validate syntax with `sshd -t` before applying changes.
- [ ] Use firewall rules appropriate to the actual network architecture.
- [ ] Keep backups of configuration and document rollback steps.

Never blindly copy a hardening snippet to a remote machine; a small mistake can lock out administrators.
