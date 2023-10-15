# IPv6 fragmentation

This is the source code for the experiments that we presented in our paper _Di Paolo, E., Bassetti, E., & Spognardi, A. (ESORICS 2023). A New Model for Testing IPv6 Fragment Handling._

## Requirements

* Vagrant
  * Plugins (install with `vagrant plugin install`): `vagrant-vbguest`, `winrm`, `winrm-elevated`, `vagrant-scp`
* VirtualBox or libvirt (for vagrant)

## Usage

The `launch-tests.sh` execute all tests for all platforms. Individual tests are launched by `attacker/attack.sh`, and they are indicated below. The resulting pcaps will be available under the `pcaps` directory in each platform directory.

## Tests

| ID | Test case                                                                  | # of experiments |
|----|----------------------------------------------------------------------------|------------------|
| 1  | ICMPv6 plain (no fragmentation)                                            | 1                |
| 2  | ICMPv6 plain with wrong checksum                                           | 1                |
| 3  | ICMPv6 fragmented with wrong checksum                                      | 1                |
| 4  | ICMPv6 fragmented no overlap                                               | 1                |
| 5  | ICMPv6 fragmented with overlap                                             | 20               |
| 6  | ICMPv6 fragmented with overlap and same ID                                 | 20               |
| 7  | ICMPv6 fragmented with overlap and different ID                            | 20               |
| 8  | ICMPv6 fragmented with overlap, same ID and permutation                    | 1440             |
| 9  | ICMPv6 fragmented with overlap, same ID and permutation, different markers | 720              |
| 10 | ICMPv6 fragmented with second fragment in overlapping                      | 2                |
