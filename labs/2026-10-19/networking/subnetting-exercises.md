# IPv4 Subnetting Exercises

Assume conventional IPv4 CIDR notation.

1. How many addresses are in a /24 block?
2. How many address bits remain for hosts in a /27?
3. Is 192.168.4.31 the network address, a host, or the broadcast address in 192.168.4.0/27?
4. What is the network prefix for 10.2.7.199/24?
5. How many /26 subnets fit inside a /24?

## Answer key

1. (2^{32-24}=256) total addresses.
2. (32-27=5) host bits, or 32 total addresses.
3. It is the last address of the first /27 block, so it is that block's broadcast address.
4. 10.2.7.0/24.
5. (2^{26-24}=4).

For typical IPv4 subnets, network and broadcast addresses are not assigned to hosts; special cases such as /31 point-to-point links have different conventions.
