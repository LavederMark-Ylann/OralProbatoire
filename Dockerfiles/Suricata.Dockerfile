FROM jasonish/suricata:6.0.9

#COPY files/suricata.yaml /etc/suricata/suricata.yaml
COPY files/influxdb.repo /etc/yum.repos.d/influxdb.repo

RUN dnf install telegraf -y

WORKDIR /pcap

#COPY files/telegraf.config /etc/telegraf/telegraf.config
#COPY scripts/suricata.sh /script/suricata.sh

ENTRYPOINT ["/script/suricata.sh"]
