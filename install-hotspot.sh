#!/bin/bash

function execsilent {
        sudo sh -c "$1" &
        PID=$!
        i=1
        sp="/-\|"
        echo -n ' '
        while [ -d /proc/$PID ]
        do
                printf "\b${sp:i++%${#sp}:1}"
        done
        }
function divhash {
        echo "############################################"
}

function divdash {
        echo "--------------------------------------------"
}

echo "#################################################"
echo "H2B - Helium Hotspot Bootstraper"
echo "Version: 0.0.1"
echo "Updated at: 2020-05-09"
echo "Author: 23Ro"
echo "github.com/23RoMax"
echo "https://23ro.de"
echo "################################################"
echo "Disclaimer:"
echo "This script is a non-official installer for the hotstpot on a raspberry pi single board computer and the RAK2245"
echo "It is intended to be used, and only tested with: Raspbian Buster Lite"
echo "May or may not be working with other SBCs"
echo "!!!!Attention: "
echo "The installation process requires a reboot. Please mind that you might need to reconnect via SSH."
DISTRO=$( lsb_release -a | grep "Description:")
if [[ $DISTRO != *"Raspbian GNU/Linux 10 (buster)"* ]]; then
        divhash
        divdash
        echo "You are not running on Raspbian GNU/LINUX 10 (buster)."
        echo "There is no guarantee that the procedure will succeed."
        divdash
        divhash
fi
read -p "Press any key to start installation process...." -n1 -s
divdash
echo "Updating all repositories..."
divdash
execsilent "apt-get update"
divdash
echo "Installing dependencies..."
divdash
execsilent "apt-get install git -y"
divhash
echo "Preparing LoRa packet-forwarder && LoRa gateway..."
divhash
echo "Packet Forwarder"
divdash
execsilent "cd .. && git clone https://github.com/Lora-net/packet_forwarder.git"
divdash
echo "LoRa Gateway"
divdash
execsilent "cd .. && git clone https://github.com/Lora-net/lora_gateway.git"
divdash
echo "Fetching the helium standard configuration for your packet forwarder..."
divdash
execsilent "mv ../packet_forwarder/lora_pkt_fwd/global_conf.json ../packet_forwarder/lora_pkt_fwd/global_conf_old.json"
execsilent "wget https://helium-media.s3-us-west-2.amazonaws.com/global_conf.json && cp global_conf.json ../packet_forwarder/lora_pkt_fwd/global_conf.json"
divdash
echo "Setting SPI Speed to 2000000"
divdash
execsilent "cp ../lora_gateway/libloragw/src/loragw_spi.native.c ../lora_gateway/libloragw/src/loragw_spi.native.c.old"
execsilent "sed \"s/#define SPI_SPEED       8000000/#define SPI_SPEED       2000000/g\" ../lora_gateway/libloragw/src/loragw_spi.native.c > loragw_spi.native.c"
execsilent "sudo rm -rf ../lora_gateway/libloragw/src/loragw_spi.native.c"
execsilent "sudo cp loragw_spi.native.c ../lora_gateway/libloragw/src/loragw_spi.native.c"
divdash
echo "Activating the SPI & I2C Interface on the Pi"
SPI=$( cat /boot/config.txt | grep "dtparam=spi=on" )
if [[ $SPI == "#dtparam=spi=on" ]]; then
        echo "SPI was turned off, turning it on"
        execsilent "sed \"s/#dtparam=spi=on/dtparam=spi=on/g\" /boot/config.txt > /boot/config_new.txt"
        execsilent "rm -rf /boot/config.txt && mv /boot/config_new.txt /boot/config.txt"
fi
I2C=$( cat /boot/config.txt | grep "dtparam=i2c_arm=on" )
if [[ $I2C == "#dtparam=i2c_arm=on" ]]; then
        echo "I2C was turned off, turning it on"
        execsilent "sed \"s/#dtparam=i2c_arm=on/dtparam=i2c_arm=on/g\" /boot/config.txt > /boot/config_new.txt"
        execsilent "rm -rf /boot/config.txt && mv /boot/config_new.txt /boot/config.txt"
fi
divhash
echo "Preparing for building"
divhash
echo "Stopping the SWAP to increase the swap size"
execsilent "sudo dphys-swapfile swapoff"
divdash
echo "Increasing swapfile size to 1024"
divdash
SWAPFILE=$( cat /etc/dphys-swapfile | grep CONF_SWAPSIZE )
echo "Swapfile reads: " $SWAPFILE
sudo cp /etc/dphys-swapfile /etc/dphys-swapfile_backup

sudo sh -c "mv /etc/dphys-swapfile /etc/dphys-swapfile_old"
sudo sh -c "cp dphys-swapfile_new /etc/dphys-swapfile"
echo $( cat /etc/dphys-swapfile )
divdash
SWAPFILE_UPDATED=$( cat /etc/dphys-swapfile | grep CONF_SWAPSIZE)
echo "Swapfile updated and reads now: " $SWAPFILE_UPDATED
divdash
echo "System will now need to reboot - please execute install-hotpot-2.sh after restart"
# sudo reboot
