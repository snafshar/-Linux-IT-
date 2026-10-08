#!/usr/bin/env python3
from mininet.net import Mininet
from mininet.node import OVSSwitch, RemoteController
from mininet.link import TCLink
from mininet.topo import Topo
from mininet.cli import CLI
from mininet.log import setLogLevel, info
import argparse, random, time

USERS=100
SERVERS=5

class EnterpriseTopo(Topo):
    def build(self):
        core=self.addSwitch("s0",protocols="OpenFlow13")
        for i in range(1,6):
            self.addSwitch("s%d"%i,protocols="OpenFlow13")
        for i in range(1,USERS+1):
            access=((i-1)//20)+1
            host="u%03d"%i
            self.addHost(host,ip="10.10.%d.%d/24"%(access,((i-1)%20)+10))
            self.addLink(host,"s%d"%access)
        for i in range(1,SERVERS+1):
            self.addHost("srv%d"%i,ip="10.20.0.%d/24"%(10+i))
            self.addLink("srv%d"%i,core)
        for i in range(1,6):
            self.addLink("s%d"%i,core,cls=TCLink,bw=100,delay="2ms")

def run(a):
    net=Mininet(topo=EnterpriseTopo(),switch=OVSSwitch,link=TCLink,autoSetMacs=True)
    net.addController(RemoteController("c0",ip=a.controller,port=a.port))
    net.start()
    time.sleep(2)
    info("*** Created 100 user namespaces and 5 server namespaces\n")
    if a.test:
        random.seed(42)
        ok=0
        for _ in range(a.flows):
            uid=random.randint(1,USERS)
            sid=random.randint(1,SERVERS)
            out=net["u%03d"%uid].cmd("ping -c 1 -W 2 10.20.0.%d"%(10+sid))
            ok += ("1 received" in out or "1 packets received" in out)
        info("*** Traffic result: %d/%d successful\n"%(ok,a.flows))
    CLI(net)
    net.stop()

if __name__=="__main__":
    p=argparse.ArgumentParser(description="100-user/5-server SDN Mininet simulation")
    p.add_argument("--controller",default="127.0.0.1")
    p.add_argument("--port",type=int,default=6653)
    p.add_argument("--test",action="store_true")
    p.add_argument("--flows",type=int,default=100)
    setLogLevel("info")
    run(p.parse_args())
