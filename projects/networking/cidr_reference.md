# CIDR subnetting quick reference

CIDR represents an IPv4 network as an address followed by a prefix length.

| Example | Netmask | Total addresses |
|---|---|---:|
| `192.168.1.0/24` | `255.255.255.0` | 256 |
| `10.0.0.0/16` | `255.255.0.0` | 65,536 |
| `172.16.8.0/21` | `255.255.248.0` | 2,048 |
| `192.0.2.64/26` | `255.255.255.192` | 64 |

These totals include network and broadcast addresses where those concepts apply.
For documentation and examples, use reserved example ranges such as 192.0.2.0/24.
