#!/bin/sh

encode_to_url_format() {
    echo "$1" | sed 's/ /%20/g'
}

check_if_empty() {
	[[ -z "$1" ]] && echo "0" || echo "$1"
}

KEY=""
CITY="New Delhi"
CITY=$(encode_to_url_format "$CITY")
WEATHER=$(curl -sf "api.openweathermap.org/data/2.5/weather?q=$CITY&appid=$KEY&units=metric")


case $1 in
	"full")
		echo $WEATHER
		;;
esac
