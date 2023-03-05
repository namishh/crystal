{ config, ... }:

{
  home = {
    file = {
      ".local/bin/fetch" = {
        executable = true;
        text = import ./eyecandy/nixfetch.nix { };
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./eyecandy/panes.nix { };
      };
      ".local/bin/wifimenu" = {
        executable = true;
        text = import ./rofiscripts/wifi.nix { };
      };
      ".local/bin/screenshotmenu" = {
        executable = true;
        text = import ./rofiscripts/screenshot.nix { };
      };
    };
  };
}
