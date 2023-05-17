{ colors }:
{
  home.file.".local/bin/lock" = {
    executable = true;
    text = ''
      #!/bin/sh
      playerctl pause
      awesome-client "awesome.emit_signal('toggle::lock')"
    '';
  };
}

