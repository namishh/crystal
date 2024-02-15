{}:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash
    exec dbus-run-session startxfce4
  '';
  home.file.".xsession".text = ''
    #!/usr/bin/env bash
    exec dbus-run-session startxfce4
  '';
}
