{}:
{
  home.file.".xinitrc".text = ''
    #!/usr/bin/env bash
    session=$1

    case $session in
        h           ) exec dbus-run-session awesome -c ~/.config/hiru/rc.lua;;
        a           ) exec dbus-run-session awesome;;
        *                 ) exec dbus-run-session awesome;;
    esac

  '';
}
