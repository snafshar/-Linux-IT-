# Linux Permissions Quiz

1. What does mode 640 mean?
2. Why does a directory need execute permission for traversal?
3. What is the difference between symbolic and numeric chmod modes?
4. What does `umask 027` change for newly created files and directories?
5. Why can a readable file still be inaccessible if a parent directory lacks traversal permission?

Try these on temporary files. Check your answers with `stat`, `namei -l`, and `umask -S`. Avoid changing permissions on system directories during the exercise.
