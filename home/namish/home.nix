{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/oxo.nix { };
  hyprland = inputs.hyprland;
  hyprland-plugins = inputs.hyprland-plugins;
  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
    {
      config = config.nixpkgs.config;
    };
  nixpkgs-f2k = inputs.nixpkgs-f2k;
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
    iconTheme.name = "reversal";
    theme.name = "phocus";
  };
  nixpkgs.overlays = [
  ];
  imports = [
    # Importing Configutations
    (import ../shared/xresources.nix { inherit colors; })
    (import ./conf/utils/swaylock/default.nix { inherit colors pkgs; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/shell/zsh/default.nix { inherit config colors pkgs lib; })
    (import ./conf/term/kitty/default.nix { inherit pkgs colors; })
    (import ./conf/utils/dunst/default.nix { inherit colors pkgs; })
    (import ./conf/term/wezterm/default.nix { inherit pkgs colors nixpkgs-f2k; })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/utils/picom/default.nix { inherit colors pkgs nixpkgs-f2k; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    #  (import ./misc/awesome.nix { inherit pkgs colors; })
    (import ./misc/neofetch.nix { inherit config colors; })
    (import ./conf/shell/tmux/default.nix { inherit pkgs; })
    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland hyprland-plugins colors; })
    #(import ./conf/ui/waybar/default.nix { inherit config pkgs lib hyprland colors; })
    (import ./misc/xinit.nix { })
    (import ./misc/eww.nix { inherit config colors; })

    # Bin files
    (import ../shared/bin/default.nix { inherit config colors; })
    (import ../shared/lock.nix { inherit colors; })
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch the-awesome-config https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/eww" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch eww https://github.com/chadcat7/crystal ${config.home.homeDirectory}/.config/eww
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/chadcat7/kodo ${config.home.homeDirectory}/.config/nvim
        fi
      '';
    };
    packages = with pkgs; [
      bc
      chromium
      catimg
      dunst
      git-lfs
      wl-clipboard
      unrar
      sway-contrib.grimshot
      trash-cli
      xss-lock
      glib
      htop
      recode
      speechd
      authenticator
      authy
      gnome.gnome-keyring
      gcc
      jdk
      nchat
      wget
      zls
      go
      gopls
      playerctl
      scc
      (pkgs.callPackage ../shared/icons/reversal.nix { })
      (pkgs.callPackage ../../derivs/phocus.nix { inherit colors; })
      cinnamon.nemo
      python310Packages.matplotlib
      neofetch
      rust-analyzer
      hsetroot
      notion-app-enhanced
      mpc-cli
      pfetch
      ffmpeg_5-full
      neovim
      xdg-desktop-portal
      imagemagick
      xorg.xev
      procps
      killall
      moreutils
      cava
      mpdris2
      socat
      pavucontrol
      fzf
      feh
      eza
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
    allowUnfreePredicate = _: true;
  };
}
