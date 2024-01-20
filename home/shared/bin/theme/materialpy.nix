_:
''
  #!/usr/bin/env python
  from material_color_utilities_python import *
  import sys 
  import subprocess
  import os 

  home = os.environ['HOME']
  themefile = sys.argv[1]

  def getExtension(file):
      return file.split(".")[-1]

  def darken(hex_color, percentage):
      hex_color = hex_color.lstrip("#")
      rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
      darkened_rgb = tuple(int(value * (1 - percentage / 100)) for value in rgb)
      darkened_hex = "#{:02x}{:02x}{:02x}".format(*darkened_rgb)

      return darkened_hex

  def lighten(hex_color, percentage):
      hex_color = hex_color.lstrip("#")
      rgb = tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))
      lightened_rgb = tuple(int(value + (255 - value) * (percentage / 100)) for value in rgb)
      lightened_hex = "#{:02x}{:02x}{:02x}".format(*lightened_rgb)

      return lightened_hex

  if not os.path.isfile(themefile):
      exit()

  if not os.path.exists(f"{home}/.cache/wallpapers/"):
      os.makedirs(f"{home}/.cache/wallpapers/")
  if os.path.isfile(f"{home}/.cache/wallpapers/material.jpg"):
      os.remove(f"{home}/.cache/wallpapers/material.jpg")
  newfile = f'{home}/.cache/wallpapers/material.jpg'
  subprocess.run(["convert", themefile, newfile])

  image = Image.open(newfile)
  colors = themeFromSourceColor(sourceColorFromImage(image))
  colorscheme = colors.get('schemes').get('dark')

  colmap = {
      "primary" : hexFromArgb(colorscheme.get_primary()),
      "onPrimary" : hexFromArgb(colorscheme.get_onPrimary()),
      "primaryContainer" : hexFromArgb(colorscheme.get_primaryContainer()),
      "onPrimaryContainer" : hexFromArgb(colorscheme.get_onPrimaryContainer()),
      "secondary" : hexFromArgb(colorscheme.get_secondary()),
      "onSecondary" : hexFromArgb(colorscheme.get_onSecondary()),
      "secondaryContainer" : hexFromArgb(colorscheme.get_secondaryContainer()),
      "onSecondaryContainer" : hexFromArgb(colorscheme.get_onSecondaryContainer()),
      "tertiary" : hexFromArgb(colorscheme.get_tertiary()),
      "onTertiary" : hexFromArgb(colorscheme.get_onTertiary()),
      "tertiaryContainer" : hexFromArgb(colorscheme.get_tertiaryContainer()),
      "onTertiaryContainer" : hexFromArgb(colorscheme.get_onTertiaryContainer()),
      "error" : hexFromArgb(colorscheme.get_error()),
      "onError" : hexFromArgb(colorscheme.get_onError()),
      "errorContainer" : hexFromArgb(colorscheme.get_errorContainer()),
      "onErrorContainer" : hexFromArgb(colorscheme.get_onErrorContainer()),
      "background" : darken(hexFromArgb(colorscheme.get_background()), 0.6),
      "onBackground" : hexFromArgb(colorscheme.get_onBackground()),
      "surface" : hexFromArgb(colorscheme.get_surface()),
      "onSurface" : hexFromArgb(colorscheme.get_onSurface()),
      "surfaceVariant" : hexFromArgb(colorscheme.get_surfaceVariant()),
      "onSurfaceVariant" : hexFromArgb(colorscheme.get_onSurfaceVariant()),
      "outline" : hexFromArgb(colorscheme.get_outline()),
      "shadow" : hexFromArgb(colorscheme.get_shadow()),
      "inverseSurface" : hexFromArgb(colorscheme.get_inverseSurface()),
      "inverseOnSurface" : hexFromArgb(colorscheme.get_inverseOnSurface()),
      "inversePrimary" : hexFromArgb(colorscheme.get_inversePrimary()),
  }

  os.popen('sed -i "/colors = import*/c\\  colors = import ../shared/cols/material.nix { };" /etc/nixos/home/namish/home.nix')
  with open('/etc/nixos/home/shared/cols/material.nix', 'w') as file:
      text=f"""{{}}:
      rec {{
        foreground = "{colmap['onBackground'][1:]}";
        background = "{darken(colmap['background'], 10)[1:]}";
        darker = "{darken(colmap['background'], 20)[1:]}";
        accent = "{colmap['onPrimaryContainer'][1:]}";
        mbg = "{lighten(colmap['background'], 5)[1:]}";

        cursorColor = "{colmap['onBackground'][1:]}";
        comment = "{colmap['surfaceVariant'][1:]}";

        color0 = "{colmap['surface'][1:]}";
        color8 = "{colmap['inverseOnSurface'][1:]}";

        color1 = "{colmap['error'][1:]}";
        color9 = "{darken(colmap['error'], 0.3)[1:]}";

        color2 = "{lighten(colmap['inversePrimary'], 10)[1:]}";
        color10 = "{lighten(colmap['inversePrimary'], 10)[1:]}";

        color3 = "{colmap['onErrorContainer'][1:]}";
        color11 = "{darken(colmap['onErrorContainer'], 0.2)[1:]}";

        color4 = "{darken(colmap['onPrimaryContainer'], 16)[1:]}";
        color12 = "{darken(colmap['onPrimaryContainer'], 16)[1:]}";

        color5 = "{colmap['tertiary'][1:]}";
        color13 = "{colmap['tertiary'][1:]}";

        color6 = "{colmap['primary'][1:]}";
        color14 = "{colmap['primary'][1:]}";

        color7 = "{colmap['inverseSurface'][1:]}";
        color15 = "{colmap['inverseSurface'][1:]}";
        name = "material";
      }}
      """
      file.write(text)
  with open(f'{home}/.config/nvim/lua/core/materia.lua', 'w') as file:
      text=f"""return {{
        foreground = "{colmap['onBackground']}",
        background = "{colmap['background']}",
        black = "{colmap['background']}",
        darker = "{darken(colmap['background'], 20)}",
        cusorline = "{lighten(colmap['background'], 5)}",

        cursor = "{colmap['onBackground']}",
        comment = "{colmap['surfaceVariant']}",

        color0 = "{colmap['surface']}",
        color8 = "{colmap['inverseOnSurface']}",

        color1 = "{colmap['error']}",
        color9 = "{darken(colmap['error'], 0.3)}",

        color2 = "{lighten(colmap['inversePrimary'], 20)}",
        color10 = "{lighten(colmap['inversePrimary'], 20)}",

        color3 = "{colmap['onErrorContainer']}",
        color11 = "{darken(colmap['onErrorContainer'], 0.2)}",

        color4 = "{darken(colmap['onPrimaryContainer'], 16)}",
        color12 = "{darken(colmap['onPrimaryContainer'], 16)}",

        color5 = "{colmap['tertiary']}",
        color13 = "{colmap['tertiary']}",

        color6 = "{colmap['primary']}",
        color14 = "{colmap['primary']}",

        color7 = "{colmap['inverseSurface']}",
        color15 = "{colmap['inverseSurface']}",
        name = "material"
      }}
      """
      file.write(text)
''
