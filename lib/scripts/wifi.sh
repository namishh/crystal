#!/usr/bin/env bash
STATUS=$(nmcli | grep wlo1 | awk 'FNR == 1 {print $2}')

if [[ $STATUS == "connected" ]]; then
    nmcli radio wifi off
    notify-send -a "wifi"  --urgency=normal "Wi-Fi" "Wi-Fi has been turned off!"
else
    nmcli radio wifi on
    notify-send -a "wifi"  --urgency=normal "Wi-Fi" "Wi-Fi has been turned on, you are back online!"
fi

