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

if args.chksum_wrong == 0:
    icmpv6 = ICMPv6EchoRequest(data=payload1+payload2)
else:
    icmpv6 = ICMPv6EchoRequest(data=payload1+payload2, cksum=1)

p1 = ip/icmpv6
send(p1)
