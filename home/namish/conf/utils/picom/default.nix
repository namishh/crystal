{ colors, pkgs, nixpkgs-f2k, ... }:
{
  services.picom = {
    enable = true;
    package = nixpkgs-f2k.packages.${pkgs.system}.picom-ft-labs;
    activeOpacity = 1.0;
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    fadeSteps = [ 0.03 0.03 ];

    opacityRules = [
      "90:class_g = 'st-256color' && !focused"
      "95:class_g = 'st-256color' && focused"
      "100:class_g = 'awesome'"
    ];
    settings = {
      #enable or disable animations
      animations = false;
      #change animation speed of windows in current tag e.g open window in current tag
      animation-stiffness-in-tag = 125;
      #change animation speed of windows when tag changes
      animation-stiffness-tag-change = 90.0;

      animation-window-mass = 0.4;
      animation-dampening = 15;
      animation-clamping = true;

      #open windows
      animation-for-open-window = "fly-in";
      #minimize or close windows
      animation-for-unmap-window = "squeeze";
      #popup windows
      animation-for-transient-window = "slide-up"; #available options: slide-up, slide-down, slide-left, slide-right, squeeze, squeeze-bottom, zoom

      #set animation for windows being transitioned out while changings tags
      animation-for-prev-tag = "slide-left";
      #enables fading for windows being transitioned out while changings tags
      enable-fading-prev-tag = true;

      #set animation for windows being transitioned in while changings tags
      animation-for-next-tag = "slide-right";
      #enables fading for windows being transitioned in while changings tags
      enable-fading-next-tag = true;
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
