# Network diagnostics

```bash
ip address
ip route
ip neigh
getent hosts example.com
ss -tulpen
```

Use `ping` to test reachability, `traceroute` or `tracepath` to inspect a route, and `curl -I https://example.com` to inspect HTTP response headers. A failed ping alone does not prove a host is down.