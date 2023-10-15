#!/usr/bin/env bash
set -xeuo pipefail
#
## Replace default URLs with HTTP so that cache servers are happy
#cat > /etc/apt/sources.list <<EOF
#deb http://deb.debian.org/debian/ bullseye main non-free contrib
#deb http://security.debian.org/debian-security bullseye-security main contrib non-free
#deb http://deb.debian.org/debian/ bullseye-updates main contrib non-free
#deb http://deb.debian.org/debian/ bullseye-backports main contrib non-free
#EOF
#
## Set a local APT proxy/cache if available
#if [ "$apt_proxy" != "" ]; then
#  echo "Acquire::http::Proxy \"$apt_proxy\";" > /etc/apt/apt.conf.d/99proxy
#fi
#
## Install requirements
#export DEBIAN_FRONTEND=noninteractive
#apt-get update
#apt-get install -yq tcpdump screen procps

ip -4 addr flush dev eth1
ip -6 addr add 2001:DB8::1/64 dev eth1
