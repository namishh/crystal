{ colors, pkgs }: {
  programs.swaylock = with colors;{
    package = pkgs.swaylock-effects;
    settings = {
      clock = true;
      color = "00000000";
      font = "Product Sans";
      show-failed-attempts = false;
      indicator = true;
      indicator-radius = 220;
      indicator-thickness = 25;
      line-color = "#${background}";
      ring-color = "${mbg}";
      inside-color = "#${background}";
      key-hl-color = "#${accent}";
      separator-color = "00000000";
      text-color = "#${foreground}";
      text-caps-lock-color = "";
      line-ver-color = "#${accent}";
      ring-ver-color = "#${accent}";
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
      bs-hl-color = "#${accent}";
      line-uses-ring = false;
      grace = 0;
      grace-no-mouse = true;
      grace-no-touch = true;
      datestr = "%d.%m";
      fade-in = "0.1";
      ignore-empty-password = true;
    };
  };

}
