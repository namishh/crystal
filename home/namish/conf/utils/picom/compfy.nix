{ colors, pkgs, nixpkgs-f2k, ... }:
{
  services.picom = {
    enable = true;
    #package = nixpkgs-f2k.packages.${pkgs.system}.picom-pijulius;
    package = pkgs.picom.overrideAttrs (oldAttrs: {
      pname = "compfy";
      buildInputs = [
        pkgs.pcre2
      ]
      ++
      oldAttrs.buildInputs;
      src = pkgs.fetchFromGitHub {
        owner = "allusive-dev";
        repo = "compfy";
        rev = "1.7.2";
        hash = "sha256-7hvzwLEG5OpJzsrYa2AaIW8X0CPyOnTLxz+rgWteNYY=";
      };
      postInstall = '''';
    });
  };
  home.file.".config/compfy/compfy.conf".text = ''

  # Enables patches for specific window managers.
  # Currently patched: "awesome", "dwm", "herb"
  wm-support = "awesome";

  #################################
  #         ANIMATIONS            #
  #################################

  # Toggles whether animations should be used for windows
  animations = true;

  # Changes animation stiffness.
  # What stiffness basically is inferring is how much the window geometry will be stretched,
  # when opening/closing windows
  animation-stiffness = 100;
  animation-window-mass = 0.5;
  animation-dampening = 12;
  animation-clamping = true;

  # Options: ("none","zoom","fly-in","slide-up","slide-down","slide-left","slide-right")
  animation-for-open-window = "slide-left";
  animation-for-unmap-window = "slide-right";

  # Exclude certain windows from having a open animation.

  # animation-open-exclude = [
  #   "class_g = 'Dunst'"
  # ];

  # Exclude certain windows from having a closing animation.

  # animation-unmap-exclude = [
  #   "class_g = 'Dunst'"
  # ];

  #################################
  #           Corners             #
  #################################

  # Adjusts the window corner rounding in pixels.
  corner-radius = 5;

  # Explicitly declare the corner-radius of individual windows.
  #
  # corners-rule = [
  #   "20:class_g    = 'Polybar'",
  #   "15:class_g    = 'Dunst'",
  # ];

   rounded-corners-exclude = [
     "window_type = 'dock'",
     "class_g = 'bar'"
    ];

  shadow = true;

  # The blur radius for shadows, in pixels. (defaults to 16)
  shadow-radius = 16;

  # The opacity of shadows. (0.0 - 1.0, defaults to 0.75)
  # shadow-opacity = 0.75;

  shadow-offset-x = -15;
  shadow-offset-y = -15;
  # shadow-color = "#000000";

  shadow-exclude = [
     "window_type = 'dock'",
     "class_g = 'awesome'"
  ];

  # FADING IS REQUIRED FOR CLOSING ANIMATIONS
  fading = false;
  # (This does not means the animations take longer, just the fading).
  fade-in-step = 0.05;
  fade-out-step = 0.05;
  # The time between steps in fade step, in milliseconds. (> 0, defaults to 10)
  # fade-delta = 10
  # fade-exclude = []
  # no-fading-openclose = false
  # no-fading-destroyed-argb = false

  inactive-opacity = 1.0;
  frame-opacity = 1.0;

  # Overrides any opacities set in `opacity-rule` when set to true.
  inactive-opacity-override = false;

  # Default opacity for active windows. (0.0 - 1.0, defaults to 1.0)
  active-opacity = 1.0;

  # Dim inactive windows. (0.0 - 1.0, defaults to 0.0)
  inactive-dim = 0.1;

  # inactive-exclude = [
  #   "class_g = 'dwm'"
  # ];


  # active-exclude = [
  #   "class_g = 'dwm'"
  # ];


  # Specify a list of opacity rules, in the format `PERCENT:PATTERN`,
  # like `50:name *= "Firefox"`.

  # opacity-rule = [
  #   "80:class_g = 'Alacritty'"
  # ];


  blur-background = false;
  blur-method = "dual_kawase";
  #
  # blur-size = 12
  #
  # blur-deviation = false
  #
  blur-strength = 5;

  # Blur kernel preset. Play around and see what looks best.
  # Options "3x3box", "5x5box", "7x7box", "3x3gaussian", "5x5gaussian", "7x7gaussian", "9x9gaussian", "11x11gaussian"
  #
  # blur-kern = "3x3box";

  # Toggle whether you want to use a blacklist or whitelist.
  # Defaults to "true"
  blur-whitelist = true;

  # Whitelist for windows to have background blurring
  blur-include = [
    "class_g = 'Alacritty'",
    "class_g = 'kitty'"
  ];

  # Blacklist for background blurring. 
  # Only works if "blur-whitelist = false;"
  #
  # blur-exclude = [
  #   "class_g = 'Firefox'"
  # ];

  #################################
  #       General Settings        #
  #################################

  # Enable remote control via D-Bus. See the man page for more details.
  # dbus = true

  # Daemonize process. Fork to background after initialization. Causes issues with certain (badly-written) drivers.
  # daemon = false

  # Specify the backend to use: `xrender`, `glx`, or `xr_glx_hybrid`.
  backend = "glx";

  # Enable/disable VSync.
  vsync = true;

  log-level = "info";

  #################################
  #           ADVANCED            #
  #################################

  # Set settings for specific window types. See Wiki for more information
  # Below is an example of how to disabled shadows on Firefox/Librewolf menus,
  # and also make sure they are considered focused so that they cannot be affected by inactive window settings.
  #
  # wintypes:
  # {
  #   utility = { shadow = false; focus = true; };
  #   popup_menu = { shadow = false; focus = true; };
  # };
  '';
}
