#!/usr/bin/env python3
"""100-user / 5-server Mininet SDN enterprise simulation."""

from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import info, setLogLevel
from mininet.net import Mininet
from mininet.node import OVSSwitch, RemoteController
from mininet.topo import Topo

import argparse
import random
import time

USERS = 100
SERVERS = 5

class EnterpriseTopo(Topo):
    def build(self):
        core = self.addSwitch("s0", protocols="OpenFlow13")
        for switch_id in range(1, 6):
            self.addSwitch(f"s{switch_id}", protocols="OpenFlow13")
        for user_id in range(1, USERS + 1):
            access = ((user_id - 1) // 20) + 1
            host = f"u{user_id:03d}"
            address = f"10.10.{access}.{((user_id - 1) % 20) + 10}/24"
            self.addHost(host, ip=address)
            self.addLink(host, f"s{access}")
        for server_id in range(1, SERVERS + 1):
            host = f"srv{server_id}"
            self.addHost(host, ip=f"10.20.0.{10 + server_id}/24")
            self.addLink(host, core)
        for switch_id in range(1, 6):
            self.addLink(f"s{switch_id}", core, cls=TCLink, bw=100, delay="2ms")

def run(args):
    net = Mininet(topo=EnterpriseTopo(), switch=OVSSwitch, link=TCLink, autoSetMacs=True)
    net.addController("c0", controller=RemoteController, ip=args.controller, port=args.port)
    net.start()
    try:
        time.sleep(2)
        info("*** Created 100 user namespaces and 5 server namespaces\n")
        if args.test:
            random.seed(42)
            successful = 0
            for _ in range(args.flows):
                user_id = random.randint(1, USERS)
                server_id = random.randint(1, SERVERS)
                output = net[f"u{user_id:03d}"].cmd(f"ping -c 1 -W 2 10.20.0.{10 + server_id}")
                if "1 received" in output or "1 packets received" in output:
                    successful += 1
            info(f"*** Traffic result: {successful}/{args.flows} successful\n")
        CLI(net)
    finally:
        net.stop()

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="100-user/5-server SDN Mininet simulation")
    parser.add_argument("--controller", default="127.0.0.1")
    parser.add_argument("--port", type=int, default=6653)
    parser.add_argument("--test", action="store_true")
    parser.add_argument("--flows", type=int, default=100)
    setLogLevel("info")
    run(parser.parse_args())