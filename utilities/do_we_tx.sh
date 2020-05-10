#/bin/bash
echo "TCP Dump started"
sudo tcpdump -AUq -i wlan0 port 1680
