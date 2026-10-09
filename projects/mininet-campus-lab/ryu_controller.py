#!/usr/bin/env python3
"""OpenFlow 1.3 learning-switch controller using Ryu."""
from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER, set_ev_cls
from ryu.lib.packet import ethernet, packet
from ryu.ofproto import ofproto_v1_3
class LearningSwitch(app_manager.RyuApp):
    OFP_VERSIONS=[ofproto_v1_3.OFP_VERSION]
    def __init__(self,*args,**kwargs): super().__init__(*args,**kwargs); self.mac_to_port={}
    def add_flow(self,dp,priority,match,actions):
        parser,ofproto=dp.ofproto_parser,dp.ofproto
        dp.send_msg(parser.OFPFlowMod(datapath=dp,priority=priority,match=match,instructions=[parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS,actions)]))
    @set_ev_cls(ofp_event.EventOFPSwitchFeatures,CONFIG_DISPATCHER)
    def switch_features(self,event):
        dp=event.msg; parser,ofproto=dp.datapath.ofproto_parser,dp.datapath.ofproto
        self.add_flow(dp.datapath,0,parser.OFPMatch(),[parser.OFPActionOutput(ofproto.OFPP_CONTROLLER,ofproto.OFPCML_NO_BUFFER)])
    @set_ev_cls(ofp_event.EventOFPPacketIn,MAIN_DISPATCHER)
    def packet_in(self,event):
        msg=event.msg; dp=msg.datapath; ofproto,parser=dp.ofproto,dp.ofproto_parser; in_port=msg.match["in_port"]
        eth=packet.Packet(msg.data).get_protocol(ethernet.ethernet)
        if eth is None or eth.ethertype==0x88CC: return
        table=self.mac_to_port.setdefault(dp.id,{}); table[eth.src]=in_port; out_port=table.get(eth.dst,ofproto.OFPP_FLOOD)
        actions=[parser.OFPActionOutput(out_port)]
        if out_port!=ofproto.OFPP_FLOOD: self.add_flow(dp,10,parser.OFPMatch(in_port=in_port,eth_dst=eth.dst),actions)
        data=None if msg.buffer_id!=ofproto.OFP_NO_BUFFER else msg.data
        dp.send_msg(parser.OFPPacketOut(datapath=dp,buffer_id=msg.buffer_id,in_port=in_port,actions=actions,data=data))
