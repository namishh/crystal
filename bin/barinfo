
#!/usr/bin/bash
black=#0f0f0f
green=#74be88
white=#dfdde0
grey=#212126
darkblue=#6d92b7
red=#da696d
blue=#6692bf
yellow=#e1b56a
interval=0

updates() {
  updates=$(checkupdates | wc -l)   # arch

  if [ -z "$updates" ]; then
    printf "  ^b$green^^c$black^ 󰳢"" ^c$green^^b$black^ 0 "
  else
    printf "  ^b$green^^c$black^ 󰳢"" ^c$green^^b$black^ $updates "
  fi
}

battery() {
  BAT_ICON=$(~/.local/bin/battery --icon)
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)%"
  echo "^c$green^ $BAT_ICON $get_capacity"
}

volume() {
  VOL_ICON="$(~/.local/bin/volume)"
  VOLUME=$(pamixer --get-volume)
  echo "^c$blue^ $VOL_ICON $VOLUME%"
}

wlan() {
  SSID=$(iwgetid -r)
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c$black^^b$blue^ 󰤨 ^d^%s""^c$blue^^b$black^ $SSID ^b$black^" ;;
	down) printf "^c$black^^b$blue^ 󰤯 ^d^%s""^c$blue^^b$black^ Disconnected ^b$black^" ;;
	esac
}

clock() {
	printf "^c$black^^b$darkblue^ 󰃭 "
  printf "^c$black^^b$blue^ $(date '+%H:%M')"
}

brightness() {
  BR_D=$(brillo)
  BR=$(echo "($BR_D+0.5)/1" | bc)
  echo "^c$yellow^ 󰃞 $BR%"
}

mem() {
  MEM=$(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)
  echo "^b$grey^^c$red^ 󰘚 ^b$black^^c$red^ $MEM ^b$black^"
}

cpu() {
  CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')
	echo "^c$grey^^b$green^ CPU ^c$green^^b$grey^ ${CPU} ^b$black^"
}

while true; do
  interval=$((interval + 1))
  sleep 1 && xsetroot -name "$(volume)  $(battery)  $(cpu) $(mem)$(wlan)$(clock) "
done

