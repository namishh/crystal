#!/usr/bin/env bash
STATUS=$(nmcli | grep wlo1 | awk 'FNR == 1 {print $2}')
SSID=$(iwgetid | awk -F '"' '{ print $2 }')
STRENGTH=$(awk 'NR==3 {printf("%.0f",$3*10/7)}' /proc/net/wireless)

toggle() {
    if [[ $STATUS == "connected" ]]; then
        nmcli radio wifi off
        notify-send --icon=window-close --urgency=normal "Wi-Fi" "Wi-Fi has been turned off!"
    else
        nmcli radio wifi on
        notify-send --icon=checkmark --urgency=normal "Wi-Fi" "Wi-Fi has been turned on, you are back online!"
    fi
}


class() {
    if [[ $STATUS == "connected" ]]; then
        echo active
    else
        echo inactive
    fi
}

ssid() {
    if [[ $STATUS == "connected" ]]; then
        echo $(iwgetid -r)

    else
        echo "n/a"
    fi
}
color() {
    if [[ $STATUS == "connected" ]]; then
        echo "green"

    else
        echo "red"
    fi
}
icon() {
    if [[ $STATUS == "connected" ]]; then
        echo "󰤨 "

    else
        echo "󰤮 "
    fi
}
speed() {
  s1=$(awk 'NR==3 {print $3}''' /proc/net/wireless)
  s2=${s1::-1}
  echo $s2
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--class" ]]; then
    class
elif [[ $1 == "--ssid" ]]; then
   ssid 
elif [[ $1 == "--color" ]]; then
   color 
elif [[ $1 == "--icon" ]]; then
   icon
elif [[ $1 == "--speed" ]]; then
   speed
fi
