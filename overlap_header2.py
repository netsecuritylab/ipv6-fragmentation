import argparse
from scapy.all import *
from scapy.layers.inet6 import *

parser = argparse.ArgumentParser()
parser.add_argument("-dst", type=str, required=True)
parser.add_argument("-ipid", type=int, required=True)

args = parser.parse_args()

payload1 = "AAAAAAAA"
payload2 = "BBBBBBBB"

args.ipid = int(args.ipid)
ip = IPv6(dst=args.dst)

# First header
icmp = ICMPv6EchoRequest(data=payload2+payload2)
csum = in6_chksum(58, ip, raw(icmp))
icmpv6 = ICMPv6EchoRequest(cksum=csum, data=payload2)

# Second header
icmp_2 = ICMPv6EchoRequest(data=payload1+payload2)
csum_2 = in6_chksum(58, ip, raw(icmp_2))
icmpv6_2 = ICMPv6EchoRequest(cksum=csum_2, data=payload1)

frag1 = IPv6ExtHdrFragment(offset=0, m=1, id=args.ipid, nh=58)
frag2 = IPv6ExtHdrFragment(offset=2, m=0, id=args.ipid, nh=58)

p1 = ip/frag1/icmpv6
p1_2 = ip/frag1/icmpv6_2
p2 = ip/frag2/payload2

send(p1)
send(p1_2)
send(p2)
