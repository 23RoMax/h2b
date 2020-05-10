#!/bin/bash

echo "Starting up"
echo "Resetting concentrator"
~/lora_gateway/reset_lgw.sh start 17
echo "Starting Gateway"
cd ~/packet_forwarder/lora_pkt_fwd/
./lora_pkt_fwd
