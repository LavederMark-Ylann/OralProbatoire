FROM ubuntu:22.04

# Install iproute2 and add default route to suricata
RUN apt-get update && apt-get install dialog apt-utils iproute2 -y

# Copy the tmNids.sh script to the container
COPY files/tmNids.sh /tmp/tmNids.sh

COPY files/target.sh /script/target.sh

ENTRYPOINT ["/script/target.sh"]