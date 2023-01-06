```sh
root@db771c29e5c3:/# traceroute --icmp 1.1.1.1
traceroute to 1.1.1.1 (1.1.1.1), 30 hops max, 60 byte packets
 1  memoire-suricata-1.memoire_internal_network (172.20.10.2)  0.078 ms  0.012 ms  0.009 ms
 2  probatoire-linux (192.168.100.1)  0.046 ms  0.110 ms  0.031 ms
 3  * * *
 4  * * *
 5  * * *
 6  * * *
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * * *
14  * * *
15  one.one.one.one (1.1.1.1)  2.625 ms  2.605 ms  2.585 ms
```

```sh
# From Attacker
/app # ping 172.20.10.10
PING 172.20.10.10 (172.20.10.10): 56 data bytes
64 bytes from 172.20.10.10: seq=0 ttl=63 time=0.229 ms
64 bytes from 172.20.10.10: seq=1 ttl=63 time=0.181 ms
64 bytes from 172.20.10.10: seq=2 ttl=63 time=0.199 ms
64 bytes from 172.20.10.10: seq=3 ttl=63 time=0.243 ms

# From Target
root@db771c29e5c3:/# tcpdump
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
06:41:11.830628 IP6 probatoire-linux > ip6-allrouters: ICMP6, router solicitation, length 16
06:41:15.053839 IP memoire-suricata-1.memoire_internal_network > db771c29e5c3: ICMP echo request, id 20, seq 0, length 64
06:41:15.053855 IP db771c29e5c3 > memoire-suricata-1.memoire_internal_network: ICMP echo reply, id 20, seq 0, length 64
06:41:16.054145 IP memoire-suricata-1.memoire_internal_network > db771c29e5c3: ICMP echo request, id 20, seq 1, length 64
06:41:16.054159 IP db771c29e5c3 > memoire-suricata-1.memoire_internal_network: ICMP echo reply, id 20, seq 1, length 64
06:41:17.054420 IP memoire-suricata-1.memoire_internal_network > db771c29e5c3: ICMP echo request, id 20, seq 2, length 64

# From Suricata (tcpdump)
06:41:15.053805 IP memoire-attacker-1.memoire_external_network > memoire-target-1.memoire_internal_network: ICMP echo request, id 20, seq 0, length 64
06:41:15.053862 IP memoire-target-1.memoire_internal_network > memoire-attacker-1.memoire_external_network: ICMP echo reply, id 20, seq 0, length 64
06:41:16.054117 IP memoire-attacker-1.memoire_external_network > memoire-target-1.memoire_internal_network: ICMP echo request, id 20, seq 1, length 64
06:41:16.054167 IP memoire-target-1.memoire_internal_network > memoire-attacker-1.memoire_external_network: ICMP echo reply, id 20, seq 1, length 64
06:41:17.054389 IP memoire-attacker-1.memoire_external_network > memoire-target-1.memoire_internal_network: ICMP echo request, id 20, seq 2, length 64
```