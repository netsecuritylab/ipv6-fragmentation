import argparse
from scapy.all import *


parser = argparse.ArgumentParser()
parser.add_argument("-dst", type=str, required=True)
parser.add_argument("-ipid", type=int, required=True)
parser.add_argument("-chksum_wrong", type=int, nargs='?', const=0)

args = parser.parse_args()

payload1 = "AAAAAAAA"
payload2 = "BBBBBBBB"

args.ipid = int(args.ipid)
ip = IPv6(dst=args.dst)

icmp = ICMPv6EchoRequest(data=payload1+payload2)

if args.chksum_wrong == 0:
    csum = in6_chksum(58, ip, raw(icmp))
    icmpv6 = ICMPv6EchoRequest(cksum=csum, data=payload1)
else:
    icmpv6 = ICMPv6EchoRequest(cksum=1, data=payload1)
    

frag1 = IPv6ExtHdrFragment(offset=0, m=1, id=args.ipid, nh=58)
frag2 = IPv6ExtHdrFragment(offset=2, m=0, id=args.ipid, nh=58)

p1 = ip/frag1/icmpv6
p2 = ip/frag2/payload2

send(p1)
send(p2)