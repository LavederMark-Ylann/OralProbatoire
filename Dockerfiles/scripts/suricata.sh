#!/bin/bash

telegraf --config /etc/telegraf/telegraf.config &

suricata -c /etc/suricata/suricata.yaml -r /pcap/ -l /var/log/suricata