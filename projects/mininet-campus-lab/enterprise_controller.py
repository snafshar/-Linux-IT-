#!/usr/bin/env python3
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER, set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet, ethernet

class EnterpriseController(app_manager.RyuApp):
    OFP_VERSIONS=[ofproto_v1_3.OFP_VERSION]
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.mac_to_port={}
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures,CONFIG_DISPATCHER)
    def features(self,ev):
        dp=ev.msg.datapath
        p=dp.ofproto_parser
        o=dp.ofproto
        actions=[p.OFPActionOutput(o.OFPP_CONTROLLER,o.OFPCML_NO_BUFFER)]
        self.add_flow(dp,0,p.OFPMatch(),actions)
    def add_flow(self,dp,priority,match,actions):
        p=dp.ofproto_parser
        o=dp.ofproto
        inst=[p.OFPInstructionActions(o.OFPIT_APPLY_ACTIONS,actions)]
        dp.send_msg(p.OFPFlowMod(datapath=dp,priority=priority,match=match,instructions=inst))
    @set_ev_cls(ofp_event.EventOFPPacketIn,MAIN_DISPATCHER)
    def packet_in(self,ev):
        msg=ev.msg
        dp=msg.datapath
        o=dp.ofproto
        p=dp.ofproto_parser
        in_port=msg.match["in_port"]
        pkt=packet.Packet(msg.data)
        eth=pkt.get_protocol(ethernet.ethernet)
        if eth is None or eth.ethertype==0x88cc:
            return
        table=self.mac_to_port.setdefault(dp.id,{})
        table[eth.src]=in_port
        out_port=table.get(eth.dst,o.OFPP_FLOOD)
        actions=[p.OFPActionOutput(out_port)]
        if out_port!=o.OFPP_FLOOD:
            self.add_flow(dp,10,p.OFPMatch(in_port=in_port,eth_dst=eth.dst),actions)
        data=None if msg.buffer_id!=o.OFP_NO_BUFFER else msg.data
        dp.send_msg(p.OFPPacketOut(datapath=dp,buffer_id=msg.buffer_id,in_port=in_port,actions=actions,data=data))
