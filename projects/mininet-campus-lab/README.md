# Mininet Campus / Enterprise SDN Lab

A scalable Linux networking laboratory combining **Mininet, Linux network namespaces, Python, Open vSwitch, OpenFlow 1.3, and Ryu SDN**.

## Enterprise topology

- 100 users: `u001`–`u100`
- 5 servers: `srv1`–`srv5`
- 5 access switches: `s1`–`s5`
- 1 core switch: `s0`
- 1 Ryu controller
- OpenFlow 1.3
- 100 Mbps / 2 ms inter-switch links

Each Mininet host runs in an isolated Linux network namespace. Python generates the topology and Ryu learns MAC addresses and installs forwarding flows dynamically.

## Run

```bash
sudo ./run-enterprise-simulation.sh
```

Or run the controller and topology separately:

```bash
ryu-manager --ofp-tcp-listen-port 6653 enterprise_controller.py
sudo python3 enterprise_simulation.py --test --flows 100
```

## Inspect the data plane

```bash
sudo ovs-ofctl -O OpenFlow13 dump-flows s0
sudo ip netns list
sudo mn -c
```

The traffic test uses a fixed random seed so repeated runs are comparable.