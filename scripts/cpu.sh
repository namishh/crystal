#!/bin/sh
CPU=$(cat /sys/class/thermal/thermal_zone*/temp)
TEMP=$((CPU / 1000))
echo $TEMP
