_:
''
  #!/usr/bin/env sh
  WALL=$1
  SCHEME=$2
  sed -i "3s/.*/   wallpaper = \"$1\"; /g" /etc/nixos/home/shared/cols/$SCHEME.nix
  cd /etc/nixos && home-manager switch --flake ".#$USER"
''
