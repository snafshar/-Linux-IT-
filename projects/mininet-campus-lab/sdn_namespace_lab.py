#!/usr/bin/env python3
"""SDN and Linux network-namespace Mininet laboratory."""
import argparse,time
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import info,setLogLevel
from mininet.net import Mininet
from mininet.node import OVSSwitch,RemoteController
from mininet.topo import Topo
class SDNCampusTopo(Topo):
    def build(self):
        for name,ip in [("h1","10.0.1.10/24"),("h2","10.0.1.20/24"),("h3","10.0.2.10/24"),("h4","10.0.2.20/24")]: self.addHost(name,ip=ip)
        self.addHost("ns1"); self.addHost("ns2")
        for name in ("s1","s2","s3"): self.addSwitch(name,protocols="OpenFlow13")
        self.addLink("h1","s1"); self.addLink("h2","s1"); self.addLink("h3","s3"); self.addLink("h4","s3")
        self.addLink("s1","s2",cls=TCLink,bw=20,delay="5ms",loss=1); self.addLink("s2","s3",cls=TCLink,bw=20,delay="5ms",loss=1)
        self.addLink("ns1","s2"); self.addLink("ns2","s2")
def run(args):
    net=Mininet(topo=SDNCampusTopo(),switch=OVSSwitch,link=TCLink,autoSetMacs=True); net.addController(RemoteController("c0",ip=args.controller,port=args.port)); net.start()
    try:
        info(f"*** Controller: {args.controller}:{args.port}\n"); time.sleep(2); net["h1"].cmdPrint("ping -c 3 10.0.2.10")
        for name in ("ns1","ns2"): info(f"*** {name}: {net[name].cmd('readlink /proc/self/ns/net').strip()}\n")
        if args.test:
            for switch_name in ("s1","s2","s3"): info(net[switch_name].cmd(f"ovs-ofctl -O OpenFlow13 dump-flows {switch_name}"))
            for name in ("ns1","ns2"): net[name].cmdPrint("ip -br link; ip route")
        CLI(net)
    finally: net.stop()
if __name__=="__main__":
    p=argparse.ArgumentParser(description="SDN namespace Mininet lab"); p.add_argument("--controller",default="127.0.0.1"); p.add_argument("--port",type=int,default=6653); p.add_argument("--test",action="store_true"); setLogLevel("info"); run(p.parse_args())
