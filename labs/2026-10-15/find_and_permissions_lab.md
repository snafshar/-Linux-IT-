# Find and Permissions Exercises

Create a sandbox first:

```bash
lab_dir=$(mktemp -d)
mkdir -p "$lab_dir/docs" "$lab_dir/data"
printf 'sample\n' > "$lab_dir/docs/readme.txt"
printf 'private\n' > "$lab_dir/data/private.txt"
chmod 600 "$lab_dir/data/private.txt"
```

Try the following and explain each result:

```bash
find "$lab_dir" -type f
find "$lab_dir" -type f -name '*.txt'
find "$lab_dir" -type f -mmin -10
stat "$lab_dir/data/private.txt"
namei -l "$lab_dir/data/private.txt"
find "$lab_dir" -type f -perm 600
```

Clean up only the sandbox you created:

```bash
rm -r -- "$lab_dir"
```

Questions: how do owner/group/other permissions work? Why do directory execute permissions matter? What does `-perm 600` match compared with `-perm -600`?
