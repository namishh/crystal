_:
''
  #!/usr/bin/env bash
  stat=$(pidof autotiling-rs)
  toggle() {
      if [[ -n $stat ]]; then
          pkill autotiling-rs
      else
          autotiling-rs &
      fi
  }

  icon() {
      if [[ -n $stat ]]; then
          echo "󰙀"
      else
          echo "󰜨"
      fi
  }

  if [[ $1 == "--toggle" ]]; then
      toggle
  elif [[ $1 == "--icon" ]]; then
      icon
  fi
''
