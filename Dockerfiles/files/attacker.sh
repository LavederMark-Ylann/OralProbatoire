#!/bin/sh

ip route del default dev eth0
ip route add default via 192.168.100.2 dev eth0
tail -f /dev/null