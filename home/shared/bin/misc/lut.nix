{ colors }:
''
  #!/usr/bin/env sh
  lutgen apply $1 -o $2 -- ${colors.background} ${colors.foreground} ${colors.color1} ${colors.color2} ${colors.color3} ${colors.color4} ${colors.color5} ${colors.color6} ${colors.color7} ${colors.color8} ${colors.color9} ${colors.color10} ${colors.color11} ${colors.color12} ${colors.color13} ${colors.color14} ${colors.color15} ${colors.cursorline} ${colors.bg2} ${colors.comment} 
''

