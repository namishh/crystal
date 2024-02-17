{ colors }:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash
    feh --bg-scale ~/.wallpapers/${colors.name}.jpg &
    xrdb -merge ~/.Xresources &
    dwmbar &
    exec dbus-run-session dwm 
  '';
}
