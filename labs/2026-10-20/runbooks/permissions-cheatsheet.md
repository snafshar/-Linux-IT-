# Linux Permissions Cheatsheet

- `id`: show current identity and groups.
- `namei -l PATH`: inspect permissions along a path.
- `stat PATH`: inspect owner, mode, and timestamps.
- `chmod u+x SCRIPT`: add execute permission for the owner only.
- `chown USER:GROUP PATH`: change ownership; requires appropriate privileges.
- `umask`: inspect the default permission mask.

Avoid blanket `chmod -R 777`. Diagnose the specific directory and process identity, then grant the minimum access needed. Test changes on a non-critical path first.
