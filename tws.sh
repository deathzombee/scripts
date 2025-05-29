#!/bin/bash
# set the bluetooth device MAC address
DEVICE_MAC=""

if [ "$1" == "-c" ]; then
    bluetoothctl connect $DEVICE_MAC
elif [ "$1" == "-d" ]; then
    bluetoothctl disconnect $DEVICE_MAC
else
    echo "Usage: $0 [-c | -d]"
    echo "  -c    Connect to the Bluetooth device"
    echo "  -d    Disconnect from the Bluetooth device"
fi
