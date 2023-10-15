#!/usr/bin/env bash
set -xuo pipefail

DEST_DIR="/tmp/pcaps"
mkdir -p "$DEST_DIR"

sleep 5

# Check if the host is reachable
ping6 -c 1 "2001:db8::1" > /dev/null
if [ $? -ne 0 ]; then
	echo "Host unreachable"
	exit 1
fi

set -e
# 1. ICMPv6 plain (no frag): ci aspettiamo che risponda
if [ ! -f "$DEST_DIR"/paxson-1.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-1.pcap &
	/opt/venv/bin/python3 /opt/plain_request.py -dst 2001:DB8::1 -ipid 5 -chksum_wrong 0
	sleep 2
	kill -SIGTERM %%
fi

# 2. ICMPv6 non frammentato con checksum sbagliato: no risposta
if [ ! -f "$DEST_DIR"/paxson-2.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-2.pcap &
	/opt/venv/bin/python3 /opt/plain_request.py -dst 2001:DB8::1 -ipid 6 -chksum_wrong 1
	sleep 2
	kill -SIGTERM %%
fi

# 3. ICMPv6 frammentato con checksum sbagliato: no risposta
if [ ! -f "$DEST_DIR"/paxson-3.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-3.pcap &
	/opt/venv/bin/python3 /opt/no_overlapping.py -dst 2001:DB8::1 -ipid 7 -chksum_wrong 1
	sleep 2
	kill -SIGTERM %%
fi

# 4. ICMPv6 frammentato, ma no overlap: ci aspettiamo che risponda
if [ ! -f "$DEST_DIR"/paxson-4.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-4.pcap &
	/opt/venv/bin/python3 /opt/no_overlapping.py -dst 2001:DB8::1 -ipid 8 -chksum_wrong 0
	sleep 2
	kill -SIGTERM %%
fi

# 5. 1 x ICMPv6 frammentato in overlap: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-5-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-5-$i.pcap &
		/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $RANDOM -reassembly_strategy $i
		sleep 2
		kill -SIGTERM %%
	fi
done

# 6. 5 x ICMPv6 frammentato in overlap stesso ID: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-6-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-6-$i.pcap &
		IPID=$RANDOM
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $IPID -reassembly_strategy $i
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 7. 5 x ICMPv6 frammentato in overlap diverso ID: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-7-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-7-$i.pcap &
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $RANDOM -reassembly_strategy $i
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 8. 5 x ICMPv6 frammentato in overlap stesso ID: no risposta
for i in $(seq 0 719); do
	if [ ! -f "$DEST_DIR"/paxson-8-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-8-$i.pcap &
		IPID=$RANDOM
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $IPID  -reassembly_strategy 0 -permutation $i
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 5b. 1 x ICMPv6 frammentato in overlap: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-5b-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-5b-$i.pcap &
		/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $RANDOM -reassembly_strategy $i -reloffset -1
		sleep 2
		kill -SIGTERM %%
	fi
done

# 6b. 5 x ICMPv6 frammentato in overlap stesso ID: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-6b-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-6b-$i.pcap &
		IPID=$RANDOM
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $IPID -reassembly_strategy $i -reloffset -1
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 7b. 5 x ICMPv6 frammentato in overlap diverso ID: no risposta
for i in $(seq 0 9); do
	if [ ! -f "$DEST_DIR"/paxson-7b-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-7b-$i.pcap &
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $RANDOM -reassembly_strategy $i -reloffset -1
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 8b. 5 x ICMPv6 frammentato in overlap stesso ID: no risposta
for i in $(seq 0 719); do
	if [ ! -f "$DEST_DIR"/paxson-8b-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-8b-$i.pcap &
		IPID=$RANDOM
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $IPID  -reassembly_strategy 0 -permutation $i -reloffset -1
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 9. (solo b) Creare secondo test di marker per frammenti successivi al primo (ripetere 6b)
for i in $(seq 0 719); do
	if [ ! -f "$DEST_DIR"/paxson-9b-$i.pcap ]; then
		tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-9b-$i.pcap &
		IPID=$RANDOM
		for j in $(seq 0 4); do
			/opt/venv/bin/python3 /opt/paxson_working2.py -dst 2001:DB8::1 -ipid $IPID -reassembly_strategy 0 -permutation $i -reloffset -1 -altpayload $(($j%2))
		done
		sleep 2
		kill -SIGTERM %%
	fi
done

# 10. Secondo frammento (in overlap col primo) con secondo header ICMPv6/UDPv6
if [ ! -f "$DEST_DIR"/paxson-10.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-10.pcap &
	/opt/venv/bin/python3 /opt/overlap_header.py -dst 2001:DB8::1 -ipid $RANDOM
	sleep 2
	kill -SIGTERM %%
fi

# 10. Secondo frammento (in overlap col primo) con secondo header ICMPv6/UDPv6
if [ ! -f "$DEST_DIR"/paxson-10-2.pcap ]; then
	tcpdump -i eth1 -s 1500 -w "$DEST_DIR"/paxson-10-2.pcap &
	/opt/venv/bin/python3 /opt/overlap_header2.py -dst 2001:DB8::1 -ipid $RANDOM
	sleep 2
	kill -SIGTERM %%
fi
