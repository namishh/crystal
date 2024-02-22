{ colors }:
{
  home.file.".dwm/autostart.sh" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      feh --bg-scale ~/.wallpapers/${colors.name}.jpg &
      dwmbar & echo $! > /tmp/db &
      dunst &
      xss-lock ~/.local/bin/dlock &
      mpDris2 &
    '';
  };
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash
    xrdb -merge ~/.Xresources &
    exec dbus-run-session dwm 
  '';
}
