#!/usr/bin/env bash

for platform in freebsd linux-debian linux-ubuntu linux-arch openbsd windows10 windows11; do
	cd "$platform" || exit
	mkdir -p pcaps/
	vagrant destroy -f
	vagrant up
	# Preload old tests to skip them
	vagrant scp pcaps/ attacker:/tmp/
	# Do tests
	vagrant ssh attacker -c "sudo bash /opt/attack.sh"
	# Save tests
	vagrant scp attacker:/tmp/pcaps/ .
	vagrant destroy -f
	cd ..
done
