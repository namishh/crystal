_:
''
  #!/usr/bin/env bash
  chosen=$(printf "  Power Off\n  Restart\n  Suspend\n  Hibernate\n  Log Out\n  Lock" | rofi -dmenu -i)

  case "$chosen" in
  	"  Power Off") poweroff ;;
  	"  Restart") reboot ;;
  	"  Suspend") systemctl suspend-then-hibernate ;;
  	"  Hibernate") systemctl hibernate ;;
  	"  Log Out") loginctl kill-user $USER ;;
  	"  Lock") swaylock ;;
  	*) exit 1 ;;
  esac

''
