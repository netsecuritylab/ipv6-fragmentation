import argparse
import itertools

from scapy.all import send
from scapy.layers.inet6 import *
from common import *

parser = argparse.ArgumentParser()
parser.add_argument("-dst", type=str, required=True)
parser.add_argument("-ipid", type=int, required=True)
parser.add_argument("-reassembly_strategy", type=int, required=True)
parser.add_argument("-permutation", type=int, default=-1)
parser.add_argument("-reloffset", type=int, default=0)
parser.add_argument("-altpayload", type=int, default=0)
args = parser.parse_args()

if args.altpayload == 1:
	MARKER_A = MARKER_AR
	MARKER_B = MARKER_BR
	MARKER_C = MARKER_CR
	MARKER_D = MARKER_DR
	MARKER_E = MARKER_ER
	MARKER_F = MARKER_FR
	MARKER_G = MARKER_GR

payload1 = MARKER_A * 3
payload2 = MARKER_B * 2
payload3 = MARKER_C * 3
payload4 = MARKER_D * 4
payload5 = MARKER_E * 3
payload6 = MARKER_F * 3
payload7 = MARKER_G * 3
ipv6_1 = IPv6(dst=args.dst)

# Prepare final packet in order to calculate the checksum
payload = ""
if args.reassembly_strategy in [0, 1, 2, 3, 4]:
	payload = MARKER_A * (12+args.reloffset)
# if args.reassembly_strategy == 0: # BSD
# 	payload = (MARKER_A * 3 + MARKER_D * 2 + MARKER_B * 1 + MARKER_C * 3 + MARKER_F * 3)
# elif args.reassembly_strategy == 1: # BSD-right
# 	payload = (MARKER_A * 1 + MARKER_D * 3 + MARKER_B * 2 + MARKER_E * 3 + MARKER_F * 3)
# elif args.reassembly_strategy == 2: # Linux
# 	payload = (MARKER_A * 3 + MARKER_D * 2 + MARKER_B * 1 + MARKER_E * 3 + MARKER_F * 3)
# elif args.reassembly_strategy == 3: # First
# 	payload = (MARKER_A * 3 + MARKER_D * 1 + MARKER_B * 2 + MARKER_C * 3 + MARKER_F * 3)
# elif args.reassembly_strategy == 4: # Last
# 	payload = (MARKER_A * 1 + MARKER_D * 4 + MARKER_B * 1 + MARKER_E * 3 + MARKER_F * 3)
elif args.reassembly_strategy == 5: # Buco
	payload = (MARKER_A * 3 + MARKER_B * 2 + MARKER_C * 3 + MARKER_F * 3)
elif args.reassembly_strategy == 6: # Buco
	payload = (MARKER_A * 3 + MARKER_B * 2 + MARKER_E * 3 + MARKER_F * 3)
elif args.reassembly_strategy == 7: # Buco
	payload = (MARKER_F * 3 + MARKER_B * 2 + MARKER_E * 3 + MARKER_A * 3)
elif args.reassembly_strategy == 8: # Buco on inizio in mezzo
	payload = (MARKER_A * 3 + MARKER_B * 2 + MARKER_E * 3 + MARKER_F * 3)
elif args.reassembly_strategy == 9: # Buco on inizio in mezzo
	payload = (MARKER_A * 3 + MARKER_B * 2 + MARKER_G * 3 + MARKER_F * 3)
else:
	print("Invalid reassembly strategy")
	exit(1)

pkt_header = ICMPv6EchoRequest(data=payload)
final_packet = ipv6_1 / pkt_header
# Calculate checksum implictly
del final_packet.cksum
final_packet = final_packet.__class__(bytes(final_packet))
# csum = in6_chksum(58, ipv6_1, raw(icmpv6))

# Create fragments
frag1 = IPv6ExtHdrFragment(offset=0, m=1, id=args.ipid, nh=58)
frag2 = IPv6ExtHdrFragment(offset=5 + args.reloffset, m=1, id=args.ipid, nh=58)
frag3 = IPv6ExtHdrFragment(offset=7 + args.reloffset, m=1, id=args.ipid, nh=58)
frag4 = IPv6ExtHdrFragment(offset=2 + args.reloffset, m=1, id=args.ipid, nh=58)
frag5 = IPv6ExtHdrFragment(offset=7 + args.reloffset, m=1, id=args.ipid, nh=58)
frag6 = IPv6ExtHdrFragment(offset=10 + args.reloffset, m=0, id=args.ipid, nh=58)
frag7 = IPv6ExtHdrFragment(offset=7 + args.reloffset, m=0, id=args.ipid, nh=58)

# Attach payload to fragments
packet1 = ipv6_1 / frag1 / ICMPv6EchoRequest(data=payload1, cksum=final_packet.cksum)
packet2 = ipv6_1 / frag2 / payload2
packet3 = ipv6_1 / frag3 / payload3
packet4 = ipv6_1 / frag4 / payload4
packet5 = ipv6_1 / frag5 / payload5
packet6 = ipv6_1 / frag6 / payload6
packet7 = ipv6_1 / frag7 / payload7

if args.reassembly_strategy == 7:
	send(packet6)
	send(packet2)
	send(packet3)
	send(packet4)
	send(packet5)
	send(packet1)
elif args.reassembly_strategy == 8:
	send(packet6)
	send(packet2)
	send(packet3)
	send(packet4)
	send(packet1)
	send(packet5)
	send(packet7)
elif args.reassembly_strategy == 9:
	send(packet6)
	send(packet2)
	send(packet3)
	send(packet4)
	send(packet1)
	send(packet5)
	send(packet7)
elif args.permutation < 0:
	send(packet1)
	send(packet2)
	send(packet3)
	send(packet4)
	send(packet5)
	send(packet6)
else:
	permutations = list(itertools.permutations([packet1, packet2, packet3, packet4, packet5, packet6]))
	for pkt in permutations[args.permutation]:
		send(pkt)
