_:
''
  #!/usr/bin/env sh
  THEME=$1
  notify-send "Changing Theme" "Setting theme to $1"
  sed -i "/colors = import*/c\  colors = import ../shared/cols/$THEME.nix { };" /etc/nixos/home/namish/home.nix
  home-manager switch -b backup --flake  /etc/nixos/#namish --keep-going
  echo $THEME > /tmp/themeName
  notify-send "Changing Theme Complete" "Current theme is now $1"
  kill -USR1 $(pidof st)
  #awesome-client 'awesome.emit_signal("colors::refresh")'
''
