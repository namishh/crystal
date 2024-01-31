{ colors }:
''
  #!/usr/bin/env bash 
  LUMIN=$3
  if [ -z "$3" ]
  then
    LUMIN=0.5
  fi
  convert $1 $1
  lutgen apply --lum $LUMIN --preserve -s 256 -l16 $1 -o $2 -- ${colors.background} ${colors.foreground} ${colors.color1} ${colors.color2} ${colors.color3} ${colors.color4} ${colors.color5} ${colors.color6} ${colors.color7} ${colors.color8} ${colors.color9} ${colors.color10} ${colors.color11} ${colors.color12} ${colors.color13} ${colors.color14} ${colors.color15} ${colors.mbg} ${colors.comment} ${colors.darker}
''

