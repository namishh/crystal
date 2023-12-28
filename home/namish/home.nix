{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/sweetpastel.nix { };
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
  nixpkgs-f2k = inputs.nixpkgs-f2k;
  ags = inputs.ags;
in
{
  # some general info  
  home.username = "namish";
  home.homeDirectory = "/home/namish";
  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  home.file.".icons/default".source =
    "${pkgs.phinger-cursors}/share/icons/phinger-cursors";


  # gtk themeing
  gtk = {
    enable = true;
    gtk3.extraConfig.gtk-decoration-layout = "menu:";
    iconTheme.name = "Papirus";
    theme.name = "phocus";
  };

  nixpkgs.overlays = [
  ];

  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };

  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch aura https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/eww" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch glacier https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/eww
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/chadcat7/kodo ${config.home.homeDirectory}/.config/nvim
        fi
      '';
    };
    packages = with pkgs; [
      bc
      git-lfs
      feh
      wl-clipboard
      sway-contrib.grimshot
      trash-cli
      xss-lock
      authy
      go
      gopls
      playerctl
      (pkgs.callPackage ../../pkgs/icons/papirus.nix { })
      (pkgs.callPackage ../../pkgs/others/phocus.nix { inherit colors; })
      cinnamon.nemo
      rust-analyzer
      mpc-cli
      ffmpeg_5-full
      neovim
      xdg-desktop-portal
      imagemagick
      xorg.xev
      procps
      redshift
      killall
      moreutils
      kitty
      mpdris2
      socat
      pavucontrol
      fzf
      swww
    ];
  };

  imports = [
    # Importing Configutations
    ags.homeManagerModules.default

    (import ../shared/xresources.nix { inherit colors; })

    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/utils/firefox/default.nix { inherit colors pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/utils/picom/default.nix { inherit colors pkgs nixpkgs-f2k; })

    # Shell
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs lib; })
    (import ./conf/shell/tmux/default.nix { inherit pkgs; })

    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland hyprland-plugins colors; })
    (import ./conf/ui/swayfx/default.nix { inherit config pkgs lib colors; })
    (import ./conf/ui/ags/default.nix { inherit pkgs; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors nixpkgs-f2k; })

    # Music thingies
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./conf/music/cava/default.nix { inherit colors; })

    # Some file generation
    (import ./misc/vencord.nix { inherit config colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./misc/xinit.nix { })
    (import ./misc/ewwags.nix { inherit config colors; })

    # Bin files
    (import ../shared/bin/default.nix { inherit config colors; })
  ];


}
