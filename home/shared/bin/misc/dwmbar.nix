{ colors }:
with colors;''
  #!/usr/bin/env bash
  black=#${background}
  green=#${color2}
  white=#${foreground}
  red=#${color9}
  blue=#${color4}
  accent=#${accent}
  cyan=#${color6}
  yellow=#${color3}
  grey=#${mbg}
  interval=0

  battery() {
    get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)%%"
    stat=$(cat /sys/class/power_supply/BAT0/status)
    if [ "$stat" = "Charging" ]; then
      printf "^b$green^^c$grey^ BAT ^b$black^"
    else 
      printf "^c$green^^b$grey^ BAT ^b$black^"
    fi
    printf "^c$white^^b$black^ $get_capacity"
  }

  music() {
    player_status=$(playerctl status) 
    if [ "$player_status" = "Playing" ]; then
      printf "^b$accent^^c$grey^ NP ^b$black^^c$white^ $(playerctl metadata title) "
    elif [ "$player_status" = "Paused" ]; then
      printf "^c$accent^^b$grey^ PA ^b$black^^c$white^ $(playerctl metadata title) "
    else 
      printf "^c$accent^^b$grey^ X ^b$black^^c$white^ Nothing Playing "
    fi
  }

  wlan() {
    SSID=$(iwgetid -r)
  	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
  	up) printf "^c$black^^b$accent^ 󰤨  ^d^%s""^c$white^^b$black^ $SSID ^b$black^" ;;
  	down) printf "^b$grey^^c$accent^ 󰤯  ^d^%s""^c$white^^b$black^ Disconnected ^b$black^" ;;
  	esac
  }

  clock() {
  	printf "^b$grey^^c$accent^   "
    printf "^c$white^^b$grey^ $(date '+%H:%M') ^b$black^"
  }

  while true; do
   interval=$((interval + 1))
   sleep 1 && xsetroot -name "$(music)$(battery) $(wlan)$(clock)"
  done
''
