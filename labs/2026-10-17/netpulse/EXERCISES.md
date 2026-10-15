# NetPulse Exercises

1. **Argument validation:** reject more than one argument with a helpful usage message.
2. **Dependency checks:** collect missing commands and show a single summary at the end.
3. **Exit status:** return a non-zero status only when a required local diagnostic cannot run; document how optional ping failures are treated.
4. **Logging:** add a --log FILE option. Quote paths so spaces work.
5. **JSON mode:** emit valid JSON without mixing human-readable messages into standard output.
6. **Testing:** run ShellCheck if available and manually test with ip, ping, or getent temporarily unavailable in a controlled PATH.
7. **Interpretation:** explain why a failed ping may be caused by a firewall rather than a broken network.

Do not add port scanning or attempt to inspect systems you do not own or administer.
