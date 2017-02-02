#!/bin/bash
PATH=/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin
test -d "/backup/tcpcaptures" || mkdir -p "/backup/tcpcaptures"
cd /backup/tcpcaptures
NOW=$(date '+%Y-%m-%d_%H-%M-%S')
TIMEOUT="5m"
timeout "${TIMEOUT}" tcpdump -ni eth0 'port 15512'  -s 4096  -w "packet_capture-${NOW}_${TIMEOUT}.pcap" || :
gzip "packet_capture-${NOW}_${TIMEOUT}.pcap"
mv "packet_capture-${NOW}_${TIMEOUT}.pcap.gz" "/backup/tcpcaptures/."

