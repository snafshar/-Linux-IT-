# IP Addresses and Routes

## Inspect interfaces

```bash
ip link show
ip address show
ip -br address
```

An interface can be administratively up but still lack a usable address or route. Inspect link state and addresses separately.

## Inspect routing

```bash
ip route
ip route get 1.1.1.1
```

The default route is used when no more-specific route matches a destination. The selected route depends on routing tables and policy rules.

## Safe exercises

1. Record the IPv4 and IPv6 addresses of each local interface.
2. Identify the default route without changing it.
3. Compare `ip route get` for two destinations.
4. Explain why a VPN may add more-specific routes.
5. Re-run the commands after switching Wi-Fi networks.

These commands inspect state only. Do not use `ip addr flush` or change routes on a remote system without a recovery plan.
