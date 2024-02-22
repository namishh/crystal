{ config, colors, walltype, ... }:
let
  wall = if colors.name == "material" then "~/.cache/wallpapers/material.jpg" else "~/.wallpapers/${colors.name}.jpg";
  w = if walltype == "image" then "swaylock -i ${wall} --effect-blur 5x5" else "swaylock -S --effect-blur 5x5";
in
{
  home = {
    file = {
      ".local/bin/swayscratch" = {
        executable = true;
        text = import ./misc/swayscratch.nix { };
      };
      ".local/bin/run" = {
        executable = true;
        text = import ./misc/run.nix { };
      };
      ".local/bin/pctl" = {
        executable = true;
        text = import ./misc/pctl.nix { };
      };
      ".local/bin/cpw" = {
        executable = true;
        text = import ./misc/copywall.nix { inherit colors; };
      };
      ".local/bin/dwmbar" = {
        executable = true;
        text = import ./misc/dwmbar.nix { inherit colors; };
      };
      ".local/bin/roundvalue" = {
        executable = true;
        text = import ./misc/roudnvalue.nix { };
      };

      ".local/bin/fetch" = {
        executable = true;
        text = import ./eyecandy/nixfetch.nix { };
      };
      ".local/bin/awefetch" = {
        executable = true;
        text = import ./eyecandy/awefetch.nix { };
      };
      ".local/bin/cols" = {
        executable = true;
        text = import ./eyecandy/colors.nix { };
      };
      ".local/bin/panes" = {
        executable = true;
        text = import ./eyecandy/panes.nix { };
      };

      ".local/bin/setTheme" = {
        executable = true;
        text = import ./theme/changeTheme.nix { };
      };
      ".local/bin/material" = {
        executable = true;
        text = import ./theme/material.nix { };
      };
      ".local/bin/materialpy" = {
        executable = true;
        text = import ./theme/materialpy.nix { };
      };
      ".local/bin/lock" =
        {
          executable = true;
          text = ''
            #!/bin/sh
            playerctl pause
            sleep 0.2
            awesome-client "awesome.emit_signal('toggle::lock')"
          '';
        };
      ".local/bin/waylock" =
        {
          executable = true;
          text = ''
            #!/bin/sh
            playerctl pause
            sleep 0.2
            ${w}
          '';
        };
      ".local/bin/dlock" =
        {
          executable = true;
          text = ''
               #!/bin/sh
               playerctl pause
               sleep 0.2
               fg_color=#${colors.foreground}ff
               wrong_color=#${colors.color9}aa
               highlight_color=#${colors.accent}ff
               verif_color=#${colors.color2}ff
               date_hour_color=#${colors.foreground}ff
               i3lock -p default -n --force-clock -i ~/.wallpapers/${colors.name}.jpg \
                 --ind-pos="w/2:h/2+158" --time-pos="w/2:h/4-5" --date-pos="w/2:h/4+55" --greeter-pos="w/2:h/2" \
                 --insidever-color=62688000 --insidewrong-color=$wrong_color --inside-color=b3b9b800 \
                 --ringver-color=$verif_color --ringwrong-color=$wrong_color --ring-color=$fg_color \
                 --keyhl-color=$highlight_color --bshl-color=$highlight_color --separator-color=dadada00 \
                 --date-color=$date_hour_color --time-color=$date_hour_color --greeter-color=$fg_color  \
                 --time-str="%I:%M" --time-size=120 \
                 --date-str="%a, %d %b" --date-size=35 \
            --greeter-text="$date_now" --greeter-size=25 \
                 --line-uses-inside --radius 115 --ring-width 15 --indicator \
                 --verif-text=""  --wrong-text="" --noinput-text="" \
                 --clock --date-font="Product Sans" --time-font="Product Sans" \
                 --pass-media-keys
          '';
        };
      ".local/bin/setWall" = {
        executable = true;
        text = import ./theme/changeWall.nix { };
      };

      ".local/bin/dmenupower" = {
        executable = true;
        text = import ./dmenu/power.nix { inherit colors; };
      };
      ".local/bin/dmenuemoji" = {
        executable = true;
        text = import ./dmenu/emoji.nix { inherit colors; };
      };


      ".local/bin/wifimenu" = {
        executable = true;
        text = import ./rofiscripts/wifi.nix { };
      };
      ".local/bin/powermenu" = {
        executable = true;
        text = import ./rofiscripts/powermenu.nix { };
      };
      ".local/bin/screenshotmenu" = {
        executable = true;
        text = import ./rofiscripts/screenshot.nix { };
      };

      ".local/bin/changebrightness" = {
        executable = true;
        text = import ./notifs/changebrightness.nix { };
      };
      ".local/bin/changevolume" = {
        executable = true;
        text = import ./notifs/changevolume.nix { };
      };

      ".local/bin/lut" = {
        executable = true;
        text = import ./lutgen/lut.nix { inherit colors; };
      };
      ".local/bin/lcon" = {
        executable = true;
        text = import ./lutgen/con.nix { };
      };
    };
  };
}
