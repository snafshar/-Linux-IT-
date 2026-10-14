# Linux permissions lab

Use a temporary directory and files you own while learning these commands.

1. Create a workspace with `mkdir -p ~/permissions-lab`.
2. Create a file with `printf 'practice\n' > ~/permissions-lab/example.txt`.
3. Inspect permissions using `ls -l ~/permissions-lab`.
4. Set owner read/write and group read using `chmod 640 ~/permissions-lab/example.txt`.
5. Inspect the result again with `stat ~/permissions-lab/example.txt`.
6. Try `umask` in your shell and create another file to compare defaults.

Avoid practising with `sudo` or changing permissions on system directories.
