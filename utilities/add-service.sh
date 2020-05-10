#!/bin/bash
echo "Installing the service"
sudo cp helium.service /etc/systemd/system/helium.service
sudo systemctl enable helium.service

