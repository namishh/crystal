{ colors }:
''
  #!/bin/sh 
  convert $1 /etc/nixos/home/images/walls/${colors.name}.jpg
''
