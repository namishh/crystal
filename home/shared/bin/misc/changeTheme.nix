_:
''
  #!/usr/bin/env sh
  THEME=$1
  sed -i "5s/.*/  colors = import ..\/shared\/cols\/$THEME.nix { };/g" /etc/nixos/home/namish/home.nix
  echo $THEME > /tmp/themeName
  home-manager switch --flake ".#$USER"
  kill -USR1 $(pidof st)
  awesome-client 'awesome.restart()'
''
