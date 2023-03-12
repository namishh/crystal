{ config, pkgs, lib, ... }:


let
  colors = import ../shared/cols/gruvbox.nix { };
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

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
    (import ./conf/music/mpd/default.nix { inherit config pkgs; })
    (import ./conf/music/ncmp/default.nix { inherit config pkgs; })
    (import ./misc/awesome.nix { inherit pkgs colors; })
    # Bin files
    (import ../shared/bin/default.nix { inherit config; })
  ];
  home = {
    packages = with pkgs; [
      (st.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
        src = fetchFromGitHub {
          owner = "chadcat7";
          repo = "best";
          rev = "b4e13bd68a4dd6e89d691c7a0721ae4c8ffc4908";
          sha256 = "0mjba15phjm4rnwz6ni6731zqw3j3wb6w9pvw0nv8ikj4ncih8r6";
        };
      }))
      neovim
      bc
      firefox
      playerctl
      (pkgs.callPackage ../shared/icons/whitesur.nix { })
      (pkgs.callPackage ../shared/gtk/gruv.nix { })
      cinnamon.nemo
      neofetch
      pfetch
      xdg-desktop-portal
      lua-language-server
      mpd
      procps
      cava
      picom
      mpdris2
      pavucontrol
      feh
      spotdl
      exa
    ];
  };
}
