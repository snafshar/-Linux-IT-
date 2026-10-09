#!/usr/bin/env python3
"""Mininet routed campus laboratory with repeatable diagnostics."""
import argparse
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import info, setLogLevel
from mininet.net import Mininet
from mininet.node import Controller, OVSSwitch
from mininet.topo import Topo

class CampusTopo(Topo):
    def build(self):
        for name, ip, router in [("h1","10.0.1.10/24","10.0.1.1"),("h2","10.0.1.20/24","10.0.1.1"),("h3","10.0.2.10/24","10.0.2.1"),("h4","10.0.2.20/24","10.0.2.1")]:
            self.addHost(name, ip=ip, defaultRoute=f"via {router}")
        self.addHost("r1"); self.addHost("r2"); self.addSwitch("s1"); self.addSwitch("s2")
        self.addLink("h1","s1"); self.addLink("h2","s1"); self.addLink("r1","s1")
        self.addLink("h3","s2"); self.addLink("h4","s2"); self.addLink("r2","s2")
        self.addLink("r1","r2",cls=TCLink,bw=20,delay="10ms",loss=1)

def configure_router(router, lan_ip, transit_ip):
    interfaces=router.intfList(); router.setIP(lan_ip,intf=interfaces[0]); router.setIP(transit_ip,intf=interfaces[1])
    router.cmd("sysctl -w net.ipv4.ip_forward=1 >/dev/null")

def run(args):
    net=Mininet(topo=CampusTopo(),switch=OVSSwitch,controller=Controller,link=TCLink,autoSetMacs=True); net.start()
    try:
        configure_router(net["r1"],"10.0.1.1/24","10.0.3.1/30"); configure_router(net["r2"],"10.0.2.1/24","10.0.3.2/30")
        net["r1"].cmd("ip route replace 10.0.2.0/24 via 10.0.3.2"); net["r2"].cmd("ip route replace 10.0.1.0/24 via 10.0.3.1")
        info("*** Cross-LAN connectivity test\n"); net["h1"].cmdPrint("ping -c 3 10.0.2.10")
        if args.test:
            net["h3"].cmd("iperf -s -D")
            try: net["h1"].cmdPrint("iperf -c 10.0.2.10 -t 5")
            finally: net["h3"].cmd("pkill -f 'iperf -s' || true")
        CLI(net)
    finally: net.stop()
if __name__=="__main__":
    p=argparse.ArgumentParser(description="Mininet routed campus lab"); p.add_argument("--test",action="store_true"); setLogLevel("info"); run(p.parse_args())
