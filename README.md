# SDN-WISE Docker Image
This repository contains the files to construct a complete SDN-WISE docker image that can execute
Mininet simulated wired networks, Cooja emulated/simulated wireless sensor networks and ONOS.

## Docker Pull Command
Download from [Docker Hub](https://hub.docker.com/)

`$ docker pull milardo/sdn-wise-docker`

## Privileged Mode
It is important to run this container in Privileged mode (`--privileged`) so that if can manipulate the network interface properties and devices. 

## Docker Run Command

on Mac OSX:

```
$ open -a XQuartz
```

In the XQuartz preferences, go to the “Security” and tick “Allow connections from network clients”
then:

```
$ ip=$(ifconfig en0 | grep inet | awk '$1=="inet" {print $2}')
$ xhost + $ip
$ docker run -it --rm --privileged -e DISPLAY=$ip:0 \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             milardo/sdn-wise-docker
```

on Linux:

```
$ docker run -it --rm --privileged -e DISPLAY \
             -v /tmp/.X11-unix:/tmp/.X11-unix \
             -v /lib/modules:/lib/modules \
             milardo/sdn-wise-docker
```