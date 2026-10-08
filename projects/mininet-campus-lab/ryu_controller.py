#!/usr/bin/env python3
"""Minimal OpenFlow 1.3 learning switch controller using Ryu."""
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER, set_ev_cls
from ryu.ofproto import ofproto_v1_3
from ryu.lib.packet import packet, ethernet

class LearningSwitch(app_manager.RyuApp):
    OFP_VERSIONS=[ofproto_v1_3.OFP_VERSION]
    def __init__(self,*args,**kwargs):
        super().__init__(*args,**kwargs)
        self.mac_to_port={}

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures,CONFIG_DISPATCHER)
    def switch_features(self,ev):
        dp=ev.msg.datapath; ofp=dp.ofproto; parser=dp.ofproto_parser
        match=parser.OFPMatch()
        actions=[parser.OFPActionOutput(ofp.OFPP_CONTROLLER,ofp.OFPCML_NO_BUFFER)]
        self.add_flow(dp,0,match,actions)

    def add_flow(self,dp,priority,match,actions):
        parser=dp.ofproto_parser; ofp=dp.ofproto
        inst=[parser.OFPInstructionActions(ofp.OFPIT_APPLY_ACTIONS,actions)]
        dp.send_msg(parser.OFPFlowMod(datapath=dp,priority=priority,match=match,instructions=inst))

    @set_ev_cls(ofp_event.EventOFPPacketIn,MAIN_DISPATCHER)
    def packet_in(self,ev):
        msg=ev.msg; dp=msg.datapath; ofp=dp.ofproto; parser=dp.ofproto_parser
        in_port=msg.match['in_port']; pkt=packet.Packet(msg.data); eth=pkt.get_protocol(ethernet.ethernet)
        if eth is None or eth.ethertype==0x88cc: return
        dpid=dp.id; self.mac_to_port.setdefault(dpid,{})[eth.src]=in_port
        out_port=self.mac_to_port[dpid].get(eth.dst,ofp.OFPP_FLOOD)
        actions=[parser.OFPActionOutput(out_port)]
        if out_port!=ofp.OFPP_FLOOD:
            match=parser.OFPMatch(in_port=in_port,eth_dst=eth.dst)
            self.add_flow(dp,1,match,actions)
        data=None if msg.buffer_id!=ofp.OFP_NO_BUFFER else msg.data
        out=parser.OFPPacketOut(datapath=dp,buffer_id=msg.buffer_id,in_port=in_port,actions=actions,data=data)
        dp.send_msg(out)