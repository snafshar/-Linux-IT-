# umask and Permissions Lab

Use a temporary directory to avoid changing real project files.

```bash
umask
umask -S
tmp=$(mktemp -d)
(
  cd "$tmp"
  umask 022
  touch ordinary.txt
  mkdir ordinary-dir
  umask 077
  touch private.txt
  mkdir private-dir
  stat -c '%a %n' ordinary.txt ordinary-dir private.txt private-dir
)
rm -r -- "$tmp"
```

Questions:
1. Why are typical new file permissions based on 666 and directories on 777?
2. How does umask remove permission bits?
3. Why is a directory's execute bit different from a file's execute bit?
4. Why should a script avoid changing a user's global umask unexpectedly?
