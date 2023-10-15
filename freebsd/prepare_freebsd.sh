#!/usr/bin/env bash
set -xeuo pipefail

sysrc ifconfig_em1_ipv6="inet6 2001:db8::1"

sysrc ipv6_network_interfaces=auto
sysrc ipv6_activate_all_interfaces=yes

sysctl net.inet.ip.forwarding=1
sysctl net.inet6.ip6.forwarding=1

service netif restart
service routing restart
