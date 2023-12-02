#!/bin/bash

xrdb -merge ~/.Xresources
picom --config $HOME/.config/picom/picom.conf
mpDris2
xss-lock lock 
mkdir -p ~/.cache/awesome/json/
