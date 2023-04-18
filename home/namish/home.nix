{ inputs, config, pkgs, lib, ... }:

let
  spicetify-nix = inputs.spicetify-nix;
  colors = import ../shared/cols/everforest.nix { };

  unstable = import
    (builtins.fetchTarball "https://github.com/nixos/nixpkgs/archive/master.tar.gz")
    {
      config = config.nixpkgs.config;
    };
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
    iconTheme.name = "WhiteSur";
    theme.name = "phocus";
  };
  nixpkgs.overlays = [
  ];
  imports = [
    # Importing Configutations
    (import ../shared/xresources.nix { inherit colors; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/music/cava/default.nix { inherit colors; })
    (import ./conf/shell/zsh/default.nix { inherit config; })
    (import ./conf/editors/vscopium/default.nix { })
    (import ./conf/music/spicetify/default.nix { inherit colors spicetify-nix pkgs; })
    (import ./conf/utils/sxhkd/default.nix { })
    (import ./conf/utils/picom/default.nix { inherit colors; })
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./misc/awesome.nix { inherit pkgs colors; })
    # Bin files
    (import ../shared/bin/default.nix { inherit config; })
    (import ../shared/lock.nix { inherit colors; })
  ];
  home = {
    activation = {
      installConfig = ''
        if [ ! -d "${config.home.homeDirectory}/.config/awesome" ]; then
          ${pkgs.git}/bin/git clone --depth 1 --branch the-awesome-config https://github.com/chadcat7/fuyu ${config.home.homeDirectory}/.config/awesome
        fi
        if [ ! -d "${config.home.homeDirectory}/.config/nvim" ]; then
          ${pkgs.git}/bin/git clone --depth 1 https://github.com/chadcat7/kodo ${config.home.homeDirectory}/.config/nvim
        fi
      '';
    };
    packages = with pkgs; [
      bc
      usbutils
      playerctl
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../../derivs/phocus.nix { inherit colors; })
      cinnamon.nemo
      neofetch
      chromium
      gcc
      notion-app-enhanced
      pfetch
      xdg-desktop-portal
      lua-language-server
      mpd
      imagemagick
      xorg.xev
      procps
      sbctl
      cava
      simplescreenrecorder
      mpdris2
      pavucontrol
      feh
      exa
    ];
  };
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreePredicate = _: true;
  };
}
