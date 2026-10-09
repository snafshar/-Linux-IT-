# Mininet Campus / Enterprise SDN Lab

A practical Linux networking lab combining Mininet, Linux namespaces, Open vSwitch, OpenFlow 1.3, Python, and Ryu.

## Labs

- campus_lab.py — routed two-LAN campus with controlled bandwidth, delay, and loss
- sdn_namespace_lab.py — remote-controller SDN topology and namespace inspection
- enterprise_simulation.py — 100 users, 5 servers, 5 access switches, and one core switch
- ryu_controller.py — reusable OpenFlow 1.3 learning switch
- enterprise_controller.py — controller used by the enterprise simulation
- run-lab.sh, run-sdn-lab.sh, run-enterprise-simulation.sh — reproducible launchers

## Enterprise topology

- 100 users
- 5 servers
- 5 access switches
- 1 core switch
- OpenFlow 1.3
- 100 Mbps / 2 ms access-to-core links
- deterministic traffic benchmark

## Run

    sudo ./run-lab.sh --test
    sudo ./run-sdn-lab.sh
    sudo ./run-enterprise-simulation.sh

Manual enterprise controller:

    ryu-manager --ofp-tcp-listen-port 6653 enterprise_controller.py
    sudo python3 enterprise_simulation.py --test --flows 100 --seed 42

Inspection:

    sudo ovs-ofctl -O OpenFlow13 dump-flows s0
    sudo ip netns list
    sudo mn -c

The simulations are deterministic where possible so routing and SDN experiments can be compared across runs.
