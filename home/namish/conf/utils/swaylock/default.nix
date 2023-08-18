{ colors, pkgs }: {
  programs.swaylock = with colors;{
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      color = "00000000";
      font = "Inter";
      show-failed-attempts = false;
      indicator = true;
      indicator-radius = 200;
      indicator-thickness = 20;
      line-color = "#${background}";
      ring-color = "${mbg}";
      inside-color = "#${background}";
      key-hl-color = "#${color4}";
      separator-color = "00000000";
      text-color = "#${foreground}";
      text-caps-lock-color = "";
      line-ver-color = "#${color4}";
      ring-ver-color = "#${color4}";
      inside-ver-color = "#${background}";
      text-ver-color = "#${foreground}";
      ring-wrong-color = "#${color9}";
      text-wrong-color = "#${color9}";
      inside-wrong-color = "#${background}";
      inside-clear-color = "#${background}";
      text-clear-color = "#${foreground}";
      ring-clear-color = "#${color5}";
      line-clear-color = "#${background}";
      line-wrong-color = "#${background}";
      bs-hl-color = "#${color4}";
      line-uses-ring = false;
      grace = 1;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d.%m";
      fade-in = "0.1";
      ignore-empty-password = true;
    };
  };

}
