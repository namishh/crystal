{ colors }:
{
  home.file.".local/bin/lock" = {
    executable = true;
    text = ''
      #!/bin/sh
      playerctl pause
      sleep 0.2
      awesome-client "awesome.emit_signal('toggle::lock')"
      #swaylock -i ~/.config/awesome/theme/walls/${colors.name}.jpg --effect-blur 10x10
    '';
  };
}
