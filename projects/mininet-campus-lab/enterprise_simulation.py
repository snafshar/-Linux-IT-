#!/usr/bin/env python3
"""100-user / 5-server Mininet SDN enterprise simulation."""
import argparse,random,time
from mininet.cli import CLI
from mininet.link import TCLink
from mininet.log import info,setLogLevel
from mininet.net import Mininet
from mininet.node import OVSSwitch,RemoteController
from mininet.topo import Topo
USERS,SERVERS=100,5
class EnterpriseTopo(Topo):
    def build(self):
        core=self.addSwitch("s0",protocols="OpenFlow13")
        for sid in range(1,6): self.addSwitch(f"s{sid}",protocols="OpenFlow13")
        for uid in range(1,USERS+1):
            access=(uid-1)//20+1; self.addHost(f"u{uid:03d}",ip=f"10.10.{access}.{(uid-1)%20+10}/24"); self.addLink(f"u{uid:03d}",f"s{access}")
        for sid in range(1,SERVERS+1): self.addHost(f"srv{sid}",ip=f"10.20.0.{10+sid}/24"); self.addLink(f"srv{sid}",core)
        for sid in range(1,6): self.addLink(f"s{sid}",core,cls=TCLink,bw=100,delay="2ms")
def run(args):
    net=Mininet(topo=EnterpriseTopo(),switch=OVSSwitch,link=TCLink,autoSetMacs=True,build=False); net.addController("c0",controller=RemoteController,ip=args.controller,port=args.port); net.build(); net.start()
    try:
        time.sleep(args.wait); info(f"*** Topology: {USERS} users, {SERVERS} servers\n")
        if args.test:
            random.seed(args.seed); successful=0
            for _ in range(args.flows):
                uid=random.randint(1,USERS); sid=random.randint(1,SERVERS); output=net[f"u{uid:03d}"].cmd(f"ping -c 1 -W 2 10.20.0.{10+sid}")
                if "1 received" in output or "1 packets received" in output: successful+=1
            info(f"*** Traffic result: {successful}/{args.flows} ({100*successful/args.flows:.1f}%)\n")
        CLI(net)
    finally: net.stop()
if __name__=="__main__":
    p=argparse.ArgumentParser(description="Enterprise SDN simulation"); p.add_argument("--controller",default="127.0.0.1"); p.add_argument("--port",type=int,default=6653); p.add_argument("--test",action="store_true"); p.add_argument("--flows",type=int,default=100); p.add_argument("--seed",type=int,default=42); p.add_argument("--wait",type=float,default=2); setLogLevel("info"); run(p.parse_args())
