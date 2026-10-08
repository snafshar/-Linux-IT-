# Mininet Routed Campus Lab

An advanced Linux networking laboratory using Mininet, Linux routing, Open vSwitch, and traffic-control emulation.

## Topology

```text
 h1  h2                 h3  h4
  \  /                   \  /
   s1                     s2
    |                     |
    r1 ===== 20 Mbps ===== r2
          10 ms / 1% loss
```

The router-to-router link deliberately introduces bandwidth limits, latency, and packet loss.

## Requirements
- Linux
- Mininet
- Open vSwitch
- Python 3
- iperf
- sudo/root privileges

## Run
```bash
chmod +x run-lab.sh
./run-lab.sh
./run-lab.sh --test
```

## Useful CLI commands
```text
nodes
net
dump
links
pingall
h1 ping -c 5 10.0.2.10
h1 traceroute -n 10.0.2.10
r1 ip route
r2 ip route
r1 sysctl net.ipv4.ip_forward
exit
```

## Learning objectives
- network namespaces and virtual Ethernet
- Linux IP forwarding
- static routing
- Open vSwitch
- Python topology programming
- bandwidth, delay, and packet-loss emulation
- ICMP and TCP diagnostics
- reproducible network experiments

## Experiments
1. Reduce the router link to 5 Mbps and compare throughput.
2. Increase delay and observe RTT.
3. Increase packet loss and compare ping statistics.
4. Remove a route and diagnose the failure.
5. Add another LAN and router.
6. Replace static routing with a dynamic routing daemon.

## Safety
The laboratory is isolated inside Mininet namespaces. It requires root privileges because Mininet creates virtual interfaces and namespaces.