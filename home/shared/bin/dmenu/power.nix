{ colors }:
''
  #!/bin/sh
  case "$(echo -e "Shutdown\nRestart\nLogout\nSuspend\nLock" | dmenu \
      -fn "Iosevka Nerd Font:size=14" \
      -nb "#${colors.darker}" \
      -nf "#${colors.foreground}" \
      -sf "#${colors.accent}" \
      -sb "#${colors.mbg}" \
       -p \
      "Power:" )" in
          Shutdown) exec systemctl poweroff;;
          Restart) exec systemctl reboot;;
          Logout) kill -HUP $XDG_SESSION_PID;;
          Suspend) exec systemctl suspend;;
          Lock) exec dlock;;
  esac
''
