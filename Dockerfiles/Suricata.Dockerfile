FROM jasonish/suricata:6.0.9

# Install iproute2 and add default route to suricata
RUN dnf update -y && dnf install kmod iptables -y

COPY files/suricata.sh /script/suricata.sh

ENTRYPOINT ["/script/suricata.sh"]
