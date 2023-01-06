#!/bin/bash

ip route del default
ip route add default via 172.20.10.2
tail -f /dev/null