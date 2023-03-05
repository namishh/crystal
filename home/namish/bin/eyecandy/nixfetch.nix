_:
''
  #> Syntax: bash
  # Colors
  f=3 b=4
  for j in f b; do
    for i in {0..7}; do
      printf -v $j$i %b "\e[''${!j}''${i}m"
    done
  done
  d=$'\e[1m'
  t=$'\e[0m'
  v=$'\e[7m'
  # OS Release
  os_name=$(cat /etc/os-release | grep -i ID= | grep -v _ | cut -f2 -d '=')
  os_vers=$(cat /etc/os-release | grep -i VERSION_ID= | cut -f2 -d '=' | tr -d '\"')
  os="$os_name $os_vers"
  # Kernel Version
  krn=$(cat /proc/version | awk '{print $3}')
  # X Session
  wm_id=$(xprop -root -notype _NET_SUPPORTING_WM_CHECK | awk '{print $5}')
  # Packages
  pkgs=$(nix-store -q --requisites /run/current-system/sw | wc -l)
  cat << EOF
              $f4\\\\  $f6\\\\ //  
             $f4==\\\\__$f6\\\\/ $f4//
               $f6//   \\\\$f4// 
            $f6==//     $f4//==
             $f6//$f4\\\\$f6 __$f4//   
            $f6// $f4/\\\\  $f6\\\\== 
              $f4// \\\\  $f6\\\\  
      $f4         os $f7.$t $os
      $f6     kernel $f7.$t $krn
      $f4      de/wm $f7.$t $wm_id
      $f6   packages $f7.$t $pkgs
          $f0 $f1 $f2 $f3 $f4 $f5 $f6 $f7 $t
  EOF
''
