#!/bin/sh

# Rename This To weather.sh and add your api key

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

WEATHER_DESC=$(echo $WEATHER | jq -r ".weather[0].main")
WEATHER_TEMP=$(echo $WEATHER | jq ".main.temp" | cut -d "." -f 1)
WEATHER_ICON_CODE=$(echo "$WEATHER" | jq -r ".weather[].icon" | head -1)
WEATHER_FEELS_LIKE=$(echo $WEATHER | jq ".main.feels_like" | cut -d "." -f 1)
WEATHER_HUMIDITY=$(echo $WEATHER | jq ".main.humidity" | cut -d "." -f 1)
WEATHER_ICON=""
WEATHER_IMAGE=""
WEATHER_HEX=""

case $WEATHER_ICON_CODE in
	"01d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clear-sky"
		WEATHER_HEX="#ffd86b"
		;;
	"01n")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clear-night"
		WEATHER_HEX="#fcdcf6"
		;;
	"02d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds"
		WEATHER_HEX="#adadff"
		;;
	"02n")
		WEATHER_ICON=" "
		WEATHER_HEX="#adadff"
		WEATHER_IMAGE="clouds-night"
		;;
	"03d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds"
		WEATHER_HEX="#adadff"
		;;
	"03n")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds-night"
		WEATHER_HEX="#adadff"
		;;
	"04d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds"
		WEATHER_HEX="#adadff"
		;;
	"04n")
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds-night"
		WEATHER_HEX="#adadff"
		;;
	"09d")
		WEATHER_ICON=""
		WEATHER_IMAGE="clouds-showers-scattered"
		WEATHER_HEX="#6b95ff"
		;;
	"09n")
		WEATHER_ICON=""
		WEATHER_IMAGE="clouds-showers-scattered"
		WEATHER_HEX="#6b95ff"
		;;
	"10d")
		WEATHER_ICON=""
		WEATHER_IMAGE="clouds-showers"
		WEATHER_HEX="#6b95ff"
		;;
	"10n")
		WEATHER_ICON=""
		WEATHER_IMAGE="clouds-showers"
		WEATHER_HEX="#6b95ff"
		;;
	"11d")
		WEATHER_ICON=""
		WEATHER_IMAGE="stroms"
		WEATHER_HEX="#ffeb57"
		;;
	"11n")
		WEATHER_ICON=""
		WEATHER_IMAGE="stroms"
		WEATHER_HEX="#ffeb57"
		;;
	"13d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="snow"
		WEATHER_HEX="#e3e6fc"
		;;
	"13n")
		WEATHER_ICON=" "
		WEATHER_IMAGE="snow"
		WEATHER_HEX="#e3e6fc"
		;;
	"50d")
		WEATHER_ICON=" "
		WEATHER_IMAGE="fog"
		WEATHER_HEX="#84afdb"
		;;
	"50n")
		WEATHER_IMAGE="fog"
		WEATHER_ICON=" "
		WEATHER_HEX="#84afdb"
		;;
	*)
		WEATHER_ICON=" "
		WEATHER_IMAGE="clouds"
		WEATHER_HEX="#adadff"
		;;
esac

case $1 in
	"current_temp")
		check_if_empty $WEATHER_TEMP
		;;
	"current_temp_fahrenheit")
		WEATHER_TEMP=$((($WEATHER_TEMP * 9 / 5) + 32))
		check_if_empty $WEATHER_TEMP
		;;
	"feels_like")
		check_if_empty $WEATHER_FEELS_LIKE
		;;
	"humidity")
		check_if_empty $WEATHER_HUMIDITY
		;;
	"weather_desc")
		[[ -z $WEATHER_DESC ]] && echo "Not Available." || echo "$WEATHER_DESC"
		;;
	"icon")
		echo $WEATHER_ICON
		;;
	"hex")
		echo $WEATHER_HEX
		;;
	"image")
		echo $WEATHER_IMAGE
		;;
	"full")
		echo $WEATHER
		;;
esac
