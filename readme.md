# H2B - Helium Hotspot Bootstrapper bash script

## What is H2B

H2B is a script that autoinstalls and autoconfigures a fully-functioning Helium DIY Hotspot on raspbian.

H2B was originally intended to speed up the setup process when having to prepare many DIY hotspots.
A simple and straightforward automation of the installation process described at [the Helium Developer Hotspot Setup](https://developer.helium.com/hotspot/developer-setup).

## Installation

Flash your Pi's SD Card with Raspbian Buster.
On most linux distributions (such like raspbian) as root, run the following:
_Mind - Raspbian comes with unzip command, others might not!_

using wget
```Shell
wget https://github.com/23RoMax/h2b/archive/master.zip
unzip master.zip
cd h2b-master/
chmod +x ./install-hotspot.sh 
chmod +x ./build.sh
./install-hotspot.sh
```

OR

using curl
```Shell
curl -LO https://github.com/23RoMax/h2b/archive/master.zip
unzip master.zip
cd h2b-master/
chmod +x ./install-hotspot.sh
chmod +x ./build.sh
./install-hotspot.sh
```
Just follow the installation procedure and have an eye out for potential error messages.


After your Pi has rebooted, reconnect via `ssh pi@ipv4ofpi` and run

```Shell
cd h2b-master/
./build.sh
```

Congratulations, you have successfully done the base installation of your hotspot.

To run it, head back to your root folder `cd ~` and issue 
```Shell
./lora_gateway/reset_lgw.sh start 17
```

To reset your concentrator via GPIO pin 17, followed by

```Shell
$ cd ~/packet_forwarder/lora_pkt_fwd
./lora_pkt_fwd
```

This is extraordinarily well explained in [the Helium Developer Documentation](https://developer.helium.com/hotspot/developer-setup#compiling-the-packet-forwarder). If you want to connect your miner right away, follow the documentation.

## Utilities

H2B comes with utilities and alternative configurations.

1. Systemd Service installation routine + the service itself
2. Startup bash script to use with the service
3. TCP Dump to debug
4. 868 MHz config json for the packet forwarder

### How to autorun the hotspot after power outages and reboots

Navigate to the utilities folder of H2B `cd utilities/` and run

```Shell
chmod +x ./run.sh
chmod +x ./add-service.sh
cp ./run.sh ~/
./add-service.sh
systemctl status helium.service
sudo systemctl start helium.service
```

Your machine will now start the package forwarder on reboot automatically.
_Mind - do not remove run.sh from your users root folder_

## Compatibility

Tested in combination with:

_LoraWAN Interfaces:_
- [Rakwireless RAK2245 PI HAT](https://store.rakwireless.com/products/rak2245-pi-hat)
- [Rakwireless RAK831 concentrator](https://store.rakwireless.com/products/rak831-gateway-module?variant=22375114801252) Tested by [TTeague](https://github.com/illperipherals)

_SBCs:_
- [Raspberry Pi 3B](https://www.raspberrypi.org/products/raspberry-pi-3-model-b/)
- [Raspberry Pi 4](https://www.raspberrypi.org/products/raspberry-pi-4-model-b/)

_Operating Systems:_
- [2020-02-13-raspbian-buster-lite](https://downloads.raspberrypi.org/raspbian_lite/images/)
- [2020-05-27 Raspberry Pi OS (32) Lite](https://downloads.raspberrypi.org/raspios_lite_armhf_latest) _Mind:_ At the time of writing this is the latest armhf stable buster lite release

## Open To-Do's

1. Adding the installation process of the service to the installation routine
2. Adding a selection process of the gateway configurations during installation routine - see [TTN config files](https://github.com/TheThingsNetwork/gateway-conf)

# Thank you

[Travis - for your help in testing and spreading the word of this script](https://github.com/illperipherals)