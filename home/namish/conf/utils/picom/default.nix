{ colors, ... }:
{
  services.picom = {
    enable = true;
    activeOpacity = 1.0;
    backend = "glx";
    extraArgs = [ "--experimental-backends" ];
    fade = true;
    fadeDelta = 4;
    fadeSteps = [ 0.03 0.03 ];

    opacityRules = [
      "90:class_g = 'st-256color' && !focused"
      "95:class_g = 'st-256color' && focused"
      "100:class_g = 'awesome'"
    ];
    settings = {
      blur-background-exclude = [
        "window_type = 'dock'"
        "class_g ~= 'slop'"
        "class_i ~= 'slop'"
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
