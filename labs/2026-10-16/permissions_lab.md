# Safe Permissions Lab

```bash
lab=$(mktemp -d)
touch "$lab/readme.txt"
mkdir "$lab/private"
chmod 640 "$lab/readme.txt"
chmod 700 "$lab/private"
stat -c '%A %a %n' "$lab/readme.txt" "$lab/private"
rm -r -- "$lab"
```

Try to predict each permission string before running `stat`. Explain read, write, and execute for owner, group, and others. Use only the temporary directory created by this exercise.
