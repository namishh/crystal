{ config, colors, ... }:
let
  wall = if colors.name == "material" then "~/.cache/wallpapers/material.jpg" else "~/.wallpapers/${colors.name}.jpg";
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
            swaylock -i ${wall} --effect-blur 10x10
          '';
        };
      ".local/bin/setWall" = {
        executable = true;
        text = import ./theme/changeWall.nix { };
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
