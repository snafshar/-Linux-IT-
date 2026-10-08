# 100 Users + 5 Servers — SDN Mininet Enterprise Simulation

A scalable Linux networking simulation using **Python, Mininet, Linux network namespaces, Open vSwitch, OpenFlow 1.3, and Ryu SDN**.

## Network model

- **100 isolated user namespaces:** `u001`–`u100`
- **5 server namespaces:** `srv1`–`srv5`
- 5 access switches
- 1 core Open vSwitch
- Ryu SDN controller
- OpenFlow 1.3
- 100 Mbps inter-switch links
- 2 ms emulated core-link delay
- deterministic randomized user-to-server traffic

Python generates the complete topology automatically, so the simulation can be scaled without manually declaring every host.

## Architecture

```text
                    Ryu SDN Controller
                            |
                        OpenFlow 1.3
                            |
                       +---------+
                       |   s0    |  Core
                       +----+----+
                      / /  |  \ \
                    s1 s2  s3  s4 s5
                    |  |   |   |  |
                 20 users per access switch
                         |
                    srv1 ... srv5
```

Each user is a Linux network namespace created by Mininet. The SDN controller programs Open vSwitch forwarding behavior.

## Files

- `enterprise_simulation.py` — scalable 100-user/5-server topology and traffic tests
- `enterprise_controller.py` — OpenFlow 1.3 Ryu controller
- `run-enterprise-simulation.sh` — controller + Mininet launcher

## Run

```bash
chmod +x run-enterprise-simulation.sh
./run-enterprise-simulation.sh
```

The launcher starts Ryu, clears stale Mininet state, creates the namespaces/switches, and runs 100 deterministic user-to-server connectivity tests.

## Useful Mininet commands

```text
nodes
net
dump
pingall
u001 ip addr
u050 ip route
s1 ovs-ofctl -O OpenFlow13 dump-flows s1
s0 ovs-ofctl -O OpenFlow13 dump-flows s0
u001 ping -c 5 10.20.0.11
u100 ip link
```

## Experiments

1. Increase `USERS` from 100 to 500 and measure startup time.
2. Increase `SERVERS` from 5 to 10.
3. Add bandwidth and packet-loss constraints to access links.
4. Implement per-user traffic quotas in the SDN controller.
5. Implement server load balancing.
6. Add VLAN/tenant isolation.
7. Export OpenFlow counters to CSV.
8. Simulate a switch failure and measure affected users.
9. Add latency-sensitive and bulk-traffic classes.

## Concepts demonstrated

- Linux network namespaces
- virtual Ethernet interfaces
- scalable Python topology generation
- SDN control plane vs data plane
- OpenFlow flow tables
- Open vSwitch
- automated traffic simulation
- connectivity measurements
- reproducible network experiments

## Cleanup

```bash
sudo mn -c
```
