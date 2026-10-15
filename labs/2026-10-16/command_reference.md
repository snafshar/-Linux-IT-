# Linux Command-Line Reference

| Need | Command | Notes |
|---|---|---|
| Current directory | `pwd` | Print working directory |
| List files | `ls -lah` | Includes hidden files and sizes |
| Locate executable | `command -v python3` | Uses shell command lookup |
| File type | `file PATH` | Reports detected file type |
| Disk capacity | `df -h` | Filesystem-level view |
| Directory size | `du -sh PATH` | Directory tree usage |
| Processes | `ps aux` | Process snapshot |
| Listening sockets | `ss -tuln` | Local TCP/UDP listeners |
| Routes | `ip route` | Kernel route table |
| Recent logs | `journalctl --since today` | May require permissions |

Read each command's manual page before using options you do not recognize.
