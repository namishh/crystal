_:
''
  #!/usr/bin/env zsh
  command="$@"
  program=$(echo "$command" | awk '{print $1}')
  if [[ "$NIX_PKG" != "" ]]; then
  	program="$NIX_PKG"
  fi
  nix-shell -p "$program" --run "$command"
'' 
