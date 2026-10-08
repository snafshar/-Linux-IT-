#!/usr/bin/env python3
"""SDN + Linux namespace Mininet laboratory."""
from mininet.net import Mininet
from mininet.node import RemoteController, OVSSwitch
from mininet.link import TCLink
from mininet.topo import Topo
from mininet.cli import CLI
from mininet.log import setLogLevel, info
import argparse, time

class SDNCampusTopo(Topo):
    def build(self):
        h1=self.addHost('h1',ip='10.0.1.10/24',defaultRoute='via 10.0.1.1')
        h2=self.addHost('h2',ip='10.0.1.20/24',defaultRoute='via 10.0.1.1')
        h3=self.addHost('h3',ip='10.0.2.10/24',defaultRoute='via 10.0.2.1')
        h4=self.addHost('h4',ip='10.0.2.20/24',defaultRoute='via 10.0.2.1')
        ns1=self.addHost('ns1'); ns2=self.addHost('ns2')
        s1=self.addSwitch('s1',protocols='OpenFlow13')
        s2=self.addSwitch('s2',protocols='OpenFlow13')
        s3=self.addSwitch('s3',protocols='OpenFlow13')
        self.addLink(h1,s1); self.addLink(h2,s1)
        self.addLink(h3,s3); self.addLink(h4,s3)
        self.addLink(s1,s2,cls=TCLink,bw=20,delay='5ms',loss=1)
        self.addLink(s2,s3,cls=TCLink,bw=20,delay='5ms',loss=1)
        self.addLink(ns1,s2); self.addLink(ns2,s2)

def namespace_demo(host):
    info('*** Namespace: %s\n' % host.name)
    info(host.cmd('readlink /proc/self/ns/net').strip()+'\n')
    info(host.cmd('ip -br addr').strip()+'\n')
    info(host.cmd('ip route').strip()+'\n')

def run(args):
    net=Mininet(topo=SDNCampusTopo(),switch=OVSSwitch,link=TCLink,autoSetMacs=True)
    controller=RemoteController('c0',ip=args.controller,port=args.port)
    net.addController(controller)
    net.start()
    info('*** SDN switches connected to controller %s:%s\n' % (args.controller,args.port))
    for name in ('ns1','ns2'): namespace_demo(net[name])
    info('*** Waiting for OpenFlow rules...\n'); time.sleep(2)
    info('*** Host connectivity test\n'); net['h1'].cmdPrint('ping -c 3 10.0.2.10')
    info('*** OpenFlow state from switches\n')
    for sw in ('s1','s2','s3'):
        info('%s:\n' % sw); info(net[sw].cmd('ovs-ofctl -O OpenFlow13 dump-flows '+sw))
    if args.test:
        info('*** Namespace isolation checks\n')
        net['ns1'].cmdPrint('hostname; ip link; ip route')
        net['ns2'].cmdPrint('hostname; ip link; ip route')
    CLI(net)
    net.stop()

if __name__=='__main__':
    p=argparse.ArgumentParser(description='SDN and Linux namespace Mininet lab')
    p.add_argument('--controller',default='127.0.0.1')
    p.add_argument('--port',type=int,default=6653)
    p.add_argument('--test',action='store_true')
    setLogLevel('info'); run(p.parse_args())