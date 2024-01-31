{ colors }:
''
  #!/bin/sh 
  convert $1 /etc/nixos/walls/${colors.name}.jpg
''
