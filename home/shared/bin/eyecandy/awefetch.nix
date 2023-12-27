_:
''
  #!/usr/bin/env bash
  # Author: https://github.com/rxyhn 

  user="$USER"
  shell="$(basename $SHELL)"
  distro=$(. /etc/os-release ; echo "$ID")
  wm="$(xprop -id $(xprop -root -notype | awk '$1=="_NET_SUPPORTING_WM_CHECK:"{print $5}') -notype -f _NET_WM_NAME 8t | grep "WM_NAME" | cut -f2 -d \")"
  kernel="$(uname -r | cut -d '-' -f1)"

  white='\033[37m'
  bold='\033[1m'
  end='\033[0m'

  printf '%b' "
   $bold$white  __________    welcome, $user $end
   $bold$white |______    |$end  
   $bold$white  ______|   |$end   os $distro
   $bold$white |   ____   |$end   sh $shell
   $bold$white |  |__  |  |$end   wm $wm
   $bold$white |_____| |__|$end   kr $kernel
  "
''
