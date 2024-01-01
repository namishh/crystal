#!/bin/bash
mpDris2 &
xrdb -merge ~/.Xresources
picom --config $HOME/.config/picom/picom.conf
xss-lock lock 
mkdir -p ~/.cache/awesome/json/
