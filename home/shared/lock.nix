{ colors }:
{
  home.file.".local/bin/lock" = {
    executable = true;
    text = ''
      #!/bin/sh

      fg=${colors.foreground}
      wrong=${colors.color1}
      highlight=${colors.background}
      date=${colors.foreground}
      verify=${colors.color4}
      convert ~/.config/awesome/theme/wallpapers/${colors.wallpaper} -filter Gaussian -blur 0x8 /tmp/wall.png
      slowfade () {
          dis=$(echo -n "$DISPLAY" | tr -c '[:alnum:]' _)
          ifc='com.github.chjj.compton'
          obj='/com/github/chjj/compton'
          if [[ "$1" == "start" ]]; then
              dbus-send --dest=$ifc.$dis \
                  $obj $ifc.opts_set string:fade_in_step double:0.02
              dbus-send --dest=$ifc.$dis \
                  $obj $ifc.opts_set string:fade_out_step double:0.02
          else
              dbus-send --dest=$ifc.$dis \
                  $obj $ifc.opts_set string:fade_in_step double:0.1
              dbus-send --dest=$ifc.$dis \
                  $obj $ifc.opts_set string:fade_out_step double:0.1
          fi
      }

      slowfade start
      i3lock --force-clock -i /tmp/wall.png  --indicator --radius=250 --ring-width=30 --inside-color="#4d576833" --ring-color=$fg --insidever-color="#4d576833" --ringver-color=$verify --insidewrong-color="#4d576833" --ringwrong-color=$wrong --line-uses-inside --keyhl-color=$verify --separator-color=$verify --bshl-color=$verify --time-str="%I:%M" --time-size=100 --date-str="%A, %d %b" --date-size=45 --verif-text="Verifying Password..." --wrong-text="Wrong Password!" --noinput-text="" --greeter-text="gib me passwrod" --time-font="Iosevka Nerd Font:weight=700" --date-font="Iosevka Nerd Font:weight=200" --verif-font="Iosevka Nerd Font:weight=400" --greeter-font="Iosevka Nerd Font" --wrong-font="Iosevka Nerd Font:weight=200" --verif-size=23 --greeter-size=23 --wrong-size=23 --date-pos="w/2:h/2+60" --greeter-pos="w/2:h/2+130" --wrong-pos="w/2:h/2+300" --verif-pos="w/2:h/2+300" --date-color=$date --time-color=$date --greeter-color=$highlight --wrong-color=$wrong --verif-color=$date --pointer=default --refresh-rate=0 --pass-media-keys --pass-volume-keys --no-modkey-text
      slowfade end
    '';
  };
}

