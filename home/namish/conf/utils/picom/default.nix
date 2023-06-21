{ colors, pkgs, nixpkgs-f2k, ... }:
{
  services.picom = {
    enable = true;
    package = nixpkgs-f2k.packages.${pkgs.system}.picom-dccsillag;
    activeOpacity = 1.0;
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    fadeSteps = [ 0.03 0.03 ];

    opacityRules = [
      "98:class_g = 'st-256color' && !focused"
      "100:class_g = 'st-256color' && focused"
      "100:class_g = 'awesome'"
    ];
    settings = {
      animations = true;
      animation-stiffness = 300.0;
      animation-dampening = 22.0;
      animation-clamping = true;
      animation-mass = 1;
      animation-for-open-window = "zoom";
      animation-for-menu-window = "slide-down";
      animation-for-transient-window = "slide-down";
      shadow = true;
      shadow-radius = 15;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      shadow-exclude = [
        "window_type = 'dock'"
        "class_g ~= 'slop'"
      ];

      blur-background-exclude = [
        "window_type = 'dock'"
        "class_g ~= 'slop'"
        "class_g ~= 'awesome'"
        "class_g ~= 'discord'"
        "class_g ~= 'firefox'"
        "class_i ~= 'slop'"
        "class_i ~= 'Spotify'"
        "name ~= 'slop'"
      ];

      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      xrender-sync-fence = true;
      use-damage = true;
      blur = {
        method = "dual_kawase";
        size = 20;
        deviation = 5.0;
      };
    };

  };
}
