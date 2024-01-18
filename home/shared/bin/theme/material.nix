_:
''
  #!/usr/bin/env python
  import sys 
  import os
  import subprocess
  import json
  import os 

  home = os.environ['HOME']
  themefile = sys.argv[1]

  def getExtension(file):
      return file.split(".")[-1]

  def runCommand(cmd):
      c = subprocess.run(cmd.split(" "), stdout=subprocess.PIPE)
      return c.stdout.decode('utf-8')

  def darken_hex_color(hex_color, percentage):
      hex_color = hex_color.lstrip("#")
      rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
      darkened_rgb = tuple(int(value * (1 - percentage / 100)) for value in rgb)
      darkened_hex = "#{:02x}{:02x}{:02x}".format(*darkened_rgb)

      return darkened_hex

  def lighten_hex_color(hex_color, percentage):
    hex_color = hex_color.lstrip("#")
    rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
    lightened_rgb = tuple(int(value + (255 - value) * (percentage / 100)) for value in rgb)
    lightened_hex = "#{:02x}{:02x}{:02x}".format(*lightened_rgb)

    return lightened_hex

  if os.path.isfile(themefile):
      if not os.path.exists(f"{home}/.cache/wallpapers/"):
          os.makedirs(f"{home}/.cache/wallpapers/")
      if os.path.isfile(f"{home}/.cache/wallpapers/material.jpg"):
          os.remove(f"{home}/.cache/wallpapers/material.jpg")
      newfile = f'{home}/.cache/wallpapers/material.jpg'
      subprocess.run(["convert", themefile, newfile]) 
    
      colors = json.loads(runCommand(f'matugen --dry-run image {newfile} --json hex' ))
      colors = colors["colors"]["dark"]
      colmap = {
          "background": lighten_hex_color(colors["surface_container_lowest"], 2),
          "darker": darken_hex_color(colors["surface_container_lowest"], 30),
          "mbg": darken_hex_color(colors["surface_container"], 15),
          "foreground": colors["inverse_surface"],
          "red": colors["error"],
          "comment":colors['outline'], 
          "darkred": darken_hex_color(colors["error"],10),
          "orange": colors["on_error_container"],
          "darkorange": darken_hex_color(colors["on_error_container"],10),
          "cyan": colors["source_color"],
          "darkcyan": darken_hex_color(colors["source_color"],10),
          "green": colors["on_primary_container"],
          "darkgreen": darken_hex_color(colors["on_primary_container"],10),
          "magenta": colors["primary_fixed"],
          "darkmagenta": darken_hex_color(colors["primary_fixed"],10),
          "blue": lighten_hex_color(colors["primary"], 15),
          "darkblue": lighten_hex_color(colors["primary"],12), 
          "accent": colors["primary"],
      }
      with open('/etc/nixos/home/shared/cols/material.nix', 'w') as file:
          text=f"""{{}}:
          rec {{
            foreground = "{colmap['foreground'][1:]}";
            background = "{colmap['background'][1:]}";
            darker = "{colmap['darker'][1:]}";
            accent = "{colmap['accent'][1:]}";
            mbg = "{colmap['mbg'][1:]}";

            cursorColor = "{colmap['foreground'][1:]}";
            comment = "{colors['outline'][1:]}";

            color0 = "{colors['surface_container'][1:]}";
            color8 = "{colors['surface_container'][1:]}";

            color1 = "{colmap['darkred'][1:]}";
            color9 = "{colmap['red'][1:]}";

            color2 = "{colmap['darkgreen'][1:]}";
            color10 = "{colmap['green'][1:]}";

            color3 = "{colmap['darkorange'][1:]}";
            color11 = "{colmap['orange'][1:]}";

            color4 = "{colmap['darkblue'][1:]}";
            color12 = "{colmap['blue'][1:]}";

            color5 = "{colmap['darkmagenta'][1:]}";
            color13 = "{colmap['magenta'][1:]}";

            color6 = "{colmap['darkcyan'][1:]}";
            color14 = "{colmap['cyan'][1:]}";

            color7 = "{colors['secondary_fixed'][1:]}";
            color15 = "{colors['secondary_fixed'][1:]}";
            name = "material";
          }}
          """
          file.write(text)
      with open(f'{home}/.config/nvim/lua/core/materia.lua', 'w') as file:
          text=f"""return {{
            comment = "{colmap['comment']}",
            background = "{colmap['background']}",
            darker = "{colmap['darker']}",
            black = "{colmap['background']}",
            foreground = "{colmap['foreground']}",
            cursorline = "{colmap['mbg']}",
            cursor = "{colmap['foreground']}",
            color0 = "{colors['surface_container']}",
            color1 = "{colmap['darkred']}",
            color2 = "{colmap['darkgreen']}",
            color3 = "{colmap['darkorange']}",
            color4 = "{colmap['darkblue']}",
            color5 = "{colmap['darkmagenta']}",
            color6 = "{colmap['darkcyan']}",
            color7 = "{colors['secondary_fixed']}",
            color8 = "{colors['surface_container']}",
            color9 = "{colmap['red']}",
            color10 = "{colmap['green']}",
            color11 = "{colmap['orange']}",
            color12 = "{colmap['blue']}",
            color13 = "{colmap['magenta']}",
            color14 = "{colmap['cyan']}",
            color15 = "{colors['secondary_fixed']}",
            name = "material"
          }}
          """
          file.write(text)
      os.popen('sed -i "/colors = import*/c\\  colors = import ../shared/cols/material.nix { };" /etc/nixos/home/namish/home.nix')
      print(colors)
      print(colmap)
''
