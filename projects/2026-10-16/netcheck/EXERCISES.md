# NetCheck Exercises

1. Run the script without arguments, then with a host name of your choice.
2. Explain why a successful DNS lookup and a failed ping can happen together.
3. Modify the output to include the current date using `date`.
4. Add an optional second argument that controls the ping timeout.
5. Run the script on a machine without network access and record which checks still work.

## Troubleshooting checklist

- Is the network interface up? Try `ip link`.
- Is a default route configured? Try `ip route`.
- Does name resolution work? Try `getent hosts example.com`.
- Is ICMP filtered by the local network or destination?
- Are the required commands installed?

Do not run network configuration commands as part of this diagnostic exercise.
