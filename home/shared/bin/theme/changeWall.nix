_:
''
  #!/usr/bin/env sh
  notify-send "Process Started" "Now Set As A Temporary Wall! Wait Some Time For Permanent Effect"
  WALL=$1
  SCHEME=$2
  sed -i "3s/.*/   wallpaper = \"$1\"; /g" /etc/nixos/home/shared/cols/$SCHEME.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER"
  notify-send "Process Finished" "You can restart awesome to check the changes"
''

