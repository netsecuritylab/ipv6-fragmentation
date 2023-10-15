#!/usr/bin/env bash
set -xeuo pipefail

ip -4 addr flush dev enp0s8
ip -6 addr add 2001:DB8::1/64 dev enp0s8
