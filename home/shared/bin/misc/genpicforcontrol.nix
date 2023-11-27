{ colors }:
''
  #!/bin/sh
  convert ~/.config/awesome/theme/walls/${colors.name}.jpg -resize 1280x720 +repage -crop 570x310+400+310 ~/.config/awesome/theme/pics/tp/${colors.name}.png
''
