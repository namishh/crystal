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
      "$screen") sleep 1 && grim "$screenshot_path" ;;
      "$area")   sleep 1 && grim -g "$(slurp)" ;;
      "$window") sleep 1 && grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ;;
      *)         exit 1 ;;
  esac
''
