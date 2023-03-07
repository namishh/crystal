{ config, pkgs, colors, ... }:

{
  home.packages = with pkgs; [ swaylock-effects ];
  programs.swaylock = {
    settings = {
      clock = true;
      color = "#${colors.background}";
      font = "Iosevka Nerd Font";
      show-failed-attempts = true;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "#${colors.background}";
      ring-color = "#${colors.mbg}";
      inside-color = "#${colors.background}";
      key-hl-color = "#${colors.color4}";
      separator-color = "00000000";
      text-color = "#${colors.foreground}";
      line-ver-color = "#${colors.color4}";
      ring-ver-color = "#${colors.color4}";
      inside-ver-color = "#${colors.background}";
      text-ver-color = "#${colors.foreground}";
      ring-wrong-color = "#${colors.color2}";
      text-wrong-color = "#${colors.color2}";
      inside-wrong-color = "#${colors.background}";
      inside-clear-color = "#${colors.background}";
      text-clear-color = "#${colors.foreground}";
      ring-clear-color = "#${colors.color4}";

      line-clear-color = "#${colors.background}";
      line-wrong-color = "#${colors.background}";
      bs-hl-color = "#${colors.color2}";
      line-uses-ring = false;
      grace = 0;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d.%m";
      fade-in = "0.1";
      ignore-empty-password = false;
    };
  };
}
