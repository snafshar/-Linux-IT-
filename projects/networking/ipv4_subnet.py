"""Inspect an IPv4 network using Python's standard library."""
from ipaddress import ip_network
import sys


def describe(cidr: str) -> dict[str, str | int]:
    network = ip_network(cidr, strict=False)
    if network.version != 4:
        raise ValueError("expected an IPv4 network")
    return {
        "network": str(network.network_address),
        "broadcast": str(network.broadcast_address),
        "prefix": network.prefixlen,
        "total_addresses": network.num_addresses,
        "netmask": str(network.netmask),
    }


if __name__ == "__main__":
    if len(sys.argv) != 2:
        raise SystemExit("Usage: python ipv4_subnet.py ADDRESS/PREFIX")
    for key, value in describe(sys.argv[1]).items():
        print(f"{key}: {value}")
