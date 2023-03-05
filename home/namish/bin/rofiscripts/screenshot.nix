_:
''
  #!/usr/bin/env sh
  #
  # Rofi powered menu to take a screenshot of the whole screen, a selected area or
  # the active window. The image is then saved and copied to the clipboard.
  # Uses: date maim notify-send rofi xclip xdotool

  save_location="$HOME/Pictures/Screenshots"
  screenshot_path="$save_location/$(date +'%Y-%m-%d-%H%M%S').png"

  screen='  Fullscreen'
  area='  Selection'
  window='  Window'

  chosen=$(printf '%s;%s;%s\n' "$screen" "$area" "$window" \
      | rofi -dmenu \
             -sep ';' \
             -l 3 \
             -selected-row 1)

  case "$chosen" in
      "$screen") extra_args='--delay=1' ;;
      "$area")   extra_args='--delay=0.1 --select' ;;
      "$window") extra_args="--delay=1 --window=$(xdotool getactivewindow)" ;;
      *)         exit 1 ;;
  esac

  # The variable is used as a command's options, so it shouldn't be quoted.
  # shellcheck disable=2086
  maim --hidecursor --quiet --quality=3 --format='png' $extra_args "$screenshot_path" && {
      xclip -selection clipboard -target 'image/png' -in "$screenshot_path"
  }

''
