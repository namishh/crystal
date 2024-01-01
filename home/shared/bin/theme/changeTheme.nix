_:
''
  #!/usr/bin/env sh
  THEME=$1
  notify-send "Changing Theme Now"
  sed -i "/colors = import*/c\  colors = import ../shared/cols/$THEME.nix { };" /etc/nixos/home/namish/home.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER"
  echo $THEME > /tmp/themeName
  notify-send "Changing Theme Complete"
  #kill -USR1 $(pidof st)
  #awesome-client 'awesome.emit_signal("colors::refresh")'
''
