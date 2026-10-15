# Storage Troubleshooting Checklist

1. `df -h`: check filesystem capacity.
2. `df -i`: check inode exhaustion.
3. `du -sh DIRECTORY`: estimate directory usage.
4. `lsblk`: inspect block devices and mount points.
5. `findmnt`: inspect mounted filesystems.
6. `journalctl -k --since today`: review recent kernel messages if permitted.

A full filesystem and exhausted inodes are different failure modes. Avoid deleting files until you identify ownership, purpose, and backup status.
