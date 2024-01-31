# in home.nix
{ pkgs, inputs, colors, ... }:
with colors;{
  imports = [
    inputs.ags.homeManagerModules.default
  ];
  home.file.".config/ags/style/_colors.scss".text = ''
    $background : #${background};
    $foreground : #${foreground};
    $background-alt : #${mbg};
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
    $accent : #${accent};

  '';
  programs.ags = {
    enable = true;
    # packages to add to gjs's runtime
    extraPackages = [ pkgs.libsoup_3 ];
  };
}
