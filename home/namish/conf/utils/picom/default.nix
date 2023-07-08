{ colors, pkgs, nixpkgs-f2k, ... }:
{
  services.picom = {
    enable = true;
    #package = nixpkgs-f2k.packages.${pkgs.system}.picom-pijulius;
    package = nixpkgs-f2k.packages.${pkgs.system}.picom-ft-labs.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "fdev31";
        repo = "picom";
        rev = "7834dd3147ba605bba5cbe911bacfa8b217c37e0";
        sha256 = "05cd3yj3lv8nk433v0j2k86mhg72pf5lijkshqwarr8hp3h00cvx";
      };
    });
    activeOpacity = 1.0;
    backend = "glx";
    fade = true;
    fadeDelta = 3;
    fadeSteps = [ 0.03 0.03 ];

    opacityRules = [
      "85:class_g = 'kitty' && !focused"
      "93:class_g = 'kitty' && focused"
      "85:class_g = 'ncmpcpppad' && !focused"
      "93:class_g = 'ncmpcpppad' && focused"
      "85:class_g = 'neofetchpad' && !focused"
      "93:class_g = 'neofetchpad' && focused"
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
      animation-for-prev-tag = "zoom";
      enable-fading-prev-tag = true;
      animation-for-next-tag = "zoom";
      enable-fading-next-tag = true;
      corner-radius = 12;
      shadow = true;
      shadow-radius = 15;
      shadow-offset-x = -15;
      shadow-offset-y = -15;
      shadow-exclude = [
        "window_type = 'desktop'"
        "class_g ~= 'awesome'"
        "class_g ~= 'slop'"
      ];
      rounded-corners-exclude = [
        "window_type = 'dock'"
        "name ~= 'slop'"
        "class_i ~= 'slop'"
      ];
      blur-background-exclude = [
        "class_g ~= 'slop'"
        "window_type = 'desktop'"
        "class_g ~= 'discord'"
        "class_g ~= 'firefox'"
        "class_i ~= 'slop'"
        "class_g ~= 'firefox'"
        "class_i ~= 'Spotify'"
        "name ~= 'slop'"
      ];
      blur = {
        method = "dual_kawase";
        strength = 5.0;
        deviation = 1.0;
        kernel = "11x11gaussian";
      };

      blur-background = false;
      blur-background-frame = true;
      blur-background-fixed = true;
      glx-no-stencil = true;
      glx-no-rebind-pixmap = true;
      xrender-sync-fence = true;
      use-damage = true;
    };

  };
}
