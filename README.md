# SDN-WISE Docker Image
This repository contains the files to construct a complete SDN-WISE docker image that can execute
Mininet simulated wired networks, Cooja emulated/simulated wireless sensor network and ONOS.

## Privileged Mode
It is important to run this container in Privileged mode (`--privileged`) so that if can manipulate the network interface properties and devices. 
