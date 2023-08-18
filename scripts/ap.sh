#!/usr/bin/env bash
STATUS="$(rfkill list | sed -n 2p | awk '{print $3}')"


toggle() {
    if [[ $STATUS == "no" ]]; then
        rfkill block all
        notify-send --urgency=normal "Airplane Mode" "Airplane mode has been turned on!"
    else
        rfkill unblock all
        notify-send --urgency=normal "Airplane Mode" "Airplane mode has been turned off!"
    fi
}

class() {
    if [[ $STATUS == "no" ]]; then
        echo inactive
    else
        echo active
    fi
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--class" ]]; then
    class
fi
