{ colors }:
''
  #!/bin/sh
  convert ~/.config/awesome/theme/wallpapers/${colors.name}/${colors.wallpaper} -resize 1920x1080 +repage -crop 380x570+600+310 -modulate 52 ~/.config/rofi/menu.png
''
