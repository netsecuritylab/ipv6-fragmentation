#!/usr/bin/env bash
set -xeuo pipefail

# Replace default URLs with HTTP so that cache servers are happy
cat > /etc/apt/sources.list <<EOF
deb http://archive.ubuntu.com/ubuntu lunar main restricted
deb http://archive.ubuntu.com/ubuntu lunar-updates main restricted
deb http://archive.ubuntu.com/ubuntu lunar universe
deb http://archive.ubuntu.com/ubuntu lunar-updates universe
deb http://archive.ubuntu.com/ubuntu lunar multiverse
deb http://archive.ubuntu.com/ubuntu lunar-updates multiverse
deb http://archive.ubuntu.com/ubuntu lunar-backports main restricted universe multiverse
deb http://security.ubuntu.com/ubuntu lunar-security main restricted
deb http://security.ubuntu.com/ubuntu lunar-security universe
deb http://security.ubuntu.com/ubuntu lunar-security multiverse
EOF

# Set a local APT proxy/cache if available
if [ "$apt_proxy" != "" ]; then
  echo "Acquire::http::Proxy \"$apt_proxy\";" > /etc/apt/apt.conf.d/99proxy
fi

# Install requirements (already installed in Ubuntu)
# export DEBIAN_FRONTEND=noninteractive
# apt-get update
# apt-get install -yq tcpdump screen procps tmux

ip -4 addr flush dev enp0s8
ip -6 addr add 2001:DB8::1/64 dev enp0s8
