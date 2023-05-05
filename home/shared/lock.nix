{ colors }:
{
  home.file.".local/bin/lock" = {
    executable = true;
    text = ''
      #!/bin/sh
      awesome-client "awesome.emit_signal('toggle::lock')"
    '';
  };
}

