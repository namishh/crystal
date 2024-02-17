{ colors }:
with colors;''
  #!/usr/bin/env bash
  black=#${background}
  green=#${color2}
  white=#${foreground}
  darkblue=#${color12}
  red=#${color9}
  blue=#${color4}
  yellow=#${color3}
  grey=#${mbg}
  interval=0

  battery() {
    get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)%%"
    printf "^c$green^^b$grey^ $get_capacity"
  }

  wlan() {
    SSID=$(iwgetid -r)
  	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
  	up) printf "^c$black^^b$blue^ 󰤨  ^d^%s""^c$blue^^b$grey^ $SSID ^b$black^" ;;
  	down) printf "^c$black^^b$blue^ 󰤯  ^d^%s""^c$blue^^b$grey^ Disconnected ^b$black^" ;;
  	esac
  }

  clock() {
  	printf "^c$black^^b$darkblue^   "
    printf "^c$blue^^b$grey^ $(date '+%H:%M') ^b$black^"
  }

  while true; do
   interval=$((interval + 1))
   sleep 1 && xsetroot -name "$(battery) $(wlan)$(clock)"
  done
''
