{}:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash
    exec dbus-run-session awesome
  '';
}
