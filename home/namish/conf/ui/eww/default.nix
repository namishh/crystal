{ config, pkgs, colors, ... }:

with colors ;{
  programs.eww = {
    enable = true;
    configDir = "${config.home.homeDirectory}/.config/eww";
    package = pkgs.eww-wayland;
  };
  home.file.".config/eww/style/_colors.scss".text = ''
    $background : #${background};
    $foreground : #${foreground};
    $background-alt : #${contrast};
    $background-light : #${color0};
    $foreground-alt : #${color7};
    $red : #${color1};
    $red-light : #${color9};

    $green : #${color2};
    $green-light : #${color10};


    $yellow : #${color3};
    $yellow-light : #${color11};

    $blue : #${color4};
    $blue-light : #${color12};

    $cyan : #${color6};
    $cyan-light : #${color14};

    $magenta : #${color5};
    $magenta-light : #${color13};

    $comment : #${comment};
    $accent : $blue-light;

  '';
}
