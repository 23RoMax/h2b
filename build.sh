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
echo "Builder"
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
sudo sh -c "cd ../packet_forwarder && sudo ./compile.sh"

