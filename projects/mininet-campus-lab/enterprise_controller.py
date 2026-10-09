#!/usr/bin/env python3
"""Ryu OpenFlow 1.3 MAC-learning controller."""

from ryu.base import app_manager
from ryu.controller import ofp_event
from ryu.controller.handler import CONFIG_DISPATCHER, MAIN_DISPATCHER, set_ev_cls
from ryu.lib.packet import ethernet, packet
from ryu.ofproto import ofproto_v1_3

class EnterpriseController(app_manager.RyuApp):
    OFP_VERSIONS = [ofproto_v1_3.OFP_VERSION]

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.mac_to_port = {}

    def add_flow(self, datapath, priority, match, actions):
        parser = datapath.ofproto_parser
        ofproto = datapath.ofproto
        instructions = [parser.OFPInstructionActions(ofproto.OFPIT_APPLY_ACTIONS, actions)]
        datapath.send_msg(parser.OFPFlowMod(datapath=datapath, priority=priority, match=match, instructions=instructions))

    @set_ev_cls(ofp_event.EventOFPSwitchFeatures, CONFIG_DISPATCHER)
    def switch_features(self, event):
        datapath = event.msg.datapath
        parser = datapath.ofproto_parser
        ofproto = datapath.ofproto
        actions = [parser.OFPActionOutput(ofproto.OFPP_CONTROLLER, ofproto.OFPCML_NO_BUFFER)]
        self.add_flow(datapath, 0, parser.OFPMatch(), actions)

    @set_ev_cls(ofp_event.EventOFPPacketIn, MAIN_DISPATCHER)
    def packet_in(self, event):
        message = event.msg
        datapath = message.datapath
        ofproto = datapath.ofproto
        parser = datapath.ofproto_parser
        in_port = message.match["in_port"]
        pkt = packet.Packet(message.data)
        eth = pkt.get_protocol(ethernet.ethernet)
        if eth is None or eth.ethertype == 0x88CC:
            return
        table = self.mac_to_port.setdefault(datapath.id, {})
        table[eth.src] = in_port
        out_port = table.get(eth.dst, ofproto.OFPP_FLOOD)
        actions = [parser.OFPActionOutput(out_port)]
        if out_port != ofproto.OFPP_FLOOD:
            match = parser.OFPMatch(in_port=in_port, eth_dst=eth.dst)
            self.add_flow(datapath, 10, match, actions)
        data = None if message.buffer_id != ofproto.OFP_NO_BUFFER else message.data
        datapath.send_msg(parser.OFPPacketOut(datapath=datapath, buffer_id=message.buffer_id, in_port=in_port, actions=actions, data=data))