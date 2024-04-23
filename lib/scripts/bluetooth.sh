#!/usr/bin/env bash
STATUS="$(bluetoothctl show | grep Powered | awk '{print $2}')"
if [ $STATUS == "yes" ]; then
    bluetoothctl power off
    notify-send -a "Bluetooth" --urgency=normal "Bluetooth" "Bluetooth has been turned off."
else
    bluetoothctl power on
    notify-send -a "Bluetooth" --urgency=normal "Bluetooth" "Bluetooth has been turned on."
fi


