# SDN + Linux Network Namespace Lab

This is the advanced version of the Mininet project. It combines **software-defined networking**, **OpenFlow 1.3**, **Linux network namespaces**, Open vSwitch, traffic control, and an external Ryu controller.

## Architecture
```text
 h1 h2 -> s1 ===== s2 ===== s3 <- h3 h4
             |       |
          OpenFlow  ns1 ns2
             |
        Ryu Controller
```

Mininet creates isolated Linux network namespaces for hosts. Open vSwitch acts as the programmable data plane. Ryu is the SDN control plane and learns MAC-to-port mappings through OpenFlow 1.3.

## Files
- `sdn_namespace_lab.py` — topology, namespaces, switches, tests
- `ryu_controller.py` — OpenFlow 1.3 learning-switch controller
- `run-sdn-lab.sh` — starts controller and laboratory

## Requirements
- Linux
- Mininet
- Open vSwitch
- Python 3
- Ryu
- sudo/root privileges

## Run
```bash
chmod +x run-sdn-lab.sh
./run-sdn-lab.sh
```

Controller log:
```bash
sudo cat /tmp/mininet-ryu.log
```

## Mininet experiments
```text
nodes
net
links
dump
pingall
sh ovs-ofctl -O OpenFlow13 dump-flows s1
sh ovs-ofctl -O OpenFlow13 dump-flows s2
ns1 ip link
ns2 ip route
h1 tcpdump -ni h1-eth0
exit
```

## What you learn
- Linux network namespaces
- virtual Ethernet pairs
- Open vSwitch
- OpenFlow 1.3
- SDN control/data-plane separation
- controller-driven forwarding
- MAC learning
- flow-table inspection
- traffic shaping and packet loss
- reproducible network experiments

## Advanced experiments
1. Stop the controller and observe control-plane failure.
2. Change the controller port and observe switch connection failure.
3. Inspect flow counters before and after a ping.
4. Add an OpenFlow rule that blocks traffic between two hosts.
5. Create a statistics-collection controller application.
6. Add a third namespace and implement an isolated tenant network.
7. Replace MAC learning with destination-IP-based forwarding.

## Cleanup
```bash
sudo mn -c
```

Everything is created inside the Mininet/namespace laboratory and is intended for an isolated Linux test environment.
