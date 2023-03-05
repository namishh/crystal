{ config, colors, ... }:

{
  programs.rofi = {
    enable = true;
    font = "Iosevka Nerd Font 12";
    extraConfig = {
      modi = "drun";
      display-drun = "";
      show-icons = true;
      drun-display-format = "{name}";
      sidebar-mode = false;
    };
    theme = import ./theme.nix { inherit config colors; };
  };
}
