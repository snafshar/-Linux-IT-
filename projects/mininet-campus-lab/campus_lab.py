#!/usr/bin/env python3
"""Advanced Mininet routed campus laboratory."""
from mininet.net import Mininet
from mininet.node import OVSSwitch, Controller
from mininet.link import TCLink
from mininet.topo import Topo
from mininet.cli import CLI
from mininet.log import setLogLevel, info
import argparse

class CampusTopo(Topo):
    def build(self):
        h1=self.addHost('h1',ip='10.0.1.10/24',defaultRoute='via 10.0.1.1')
        h2=self.addHost('h2',ip='10.0.1.20/24',defaultRoute='via 10.0.1.1')
        h3=self.addHost('h3',ip='10.0.2.10/24',defaultRoute='via 10.0.2.1')
        h4=self.addHost('h4',ip='10.0.2.20/24',defaultRoute='via 10.0.2.1')
        r1=self.addHost('r1'); r2=self.addHost('r2')
        s1=self.addSwitch('s1'); s2=self.addSwitch('s2')
        self.addLink(h1,s1); self.addLink(h2,s1); self.addLink(r1,s1)
        self.addLink(h3,s2); self.addLink(h4,s2); self.addLink(r2,s2)
        self.addLink(r1,r2,cls=TCLink,bw=20,delay='10ms',loss=1)

def run(args):
    net=Mininet(topo=CampusTopo(),switch=OVSSwitch,controller=Controller,link=TCLink,autoSetMacs=True)
    net.start()
    r1,r2=net['r1'],net['r2']
    r1.setIP('10.0.1.1/24',intf=r1.intfList()[0]); r1.setIP('10.0.3.1/30',intf=r1.intfList()[1])
    r2.setIP('10.0.2.1/24',intf=r2.intfList()[0]); r2.setIP('10.0.3.2/30',intf=r2.intfList()[1])
    r1.cmd('sysctl -w net.ipv4.ip_forward=1 >/dev/null'); r2.cmd('sysctl -w net.ipv4.ip_forward=1 >/dev/null')
    r1.cmd('ip route add 10.0.2.0/24 via 10.0.3.2'); r2.cmd('ip route add 10.0.1.0/24 via 10.0.3.1')
    info('*** Cross-LAN connectivity test\n'); net['h1'].cmdPrint('ping -c 3 10.0.2.10')
    if args.test:
        info('*** Throughput test\n'); net['h3'].cmd('iperf -s -D'); net['h1'].cmdPrint('iperf -c 10.0.2.10 -t 5'); net['h3'].cmd("pkill -f 'iperf -s' || true")
    info('*** Use the Mininet CLI for experiments.\n'); CLI(net); net.stop()

if __name__=='__main__':
    p=argparse.ArgumentParser(description='Mininet routed campus lab'); p.add_argument('--test',action='store_true')
    setLogLevel('info'); run(p.parse_args())