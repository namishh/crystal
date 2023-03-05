{ config, pkgs, lib, ... }:


let
  colors = import ./cols/everforest.nix { };
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

  hyprland = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/hyprwm/Hyprland/archive/master.tar.gz";
  }).defaultNix;
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

  imports = [
    # Importing Configutations
    (import ./xresources.nix { inherit colors; })
    (import ./conf/utils/rofi/default.nix { inherit config colors; })
    (import ./conf/shell/zsh/default.nix { inherit config; })
    (import ./conf/music/mpd/default.nix { inherit config; })
    (import ./conf/music/ncmp/default.nix { inherit config; })
    (import ./conf/ui/hyprland/default.nix { inherit config pkgs lib hyprland colors; })
    (import ./conf/ui/eww/default.nix { inherit config pkgs colors lib; })

    # Bin files
    (import ./bin/default.nix { inherit config; })
  ];
  home = {

    packages = with pkgs; [
      neovim
      eww-wayland
      # my custom chad st build less goooooo
      (st.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ harfbuzz ];
        src = builtins.fetchTarball {
          url = "https://github.com/chadcat5207/best/archive/main.tar.gz";
        };
      }))
      material-design-icons
      swaybg
      ## icon and gtk theme
      (pkgs.callPackage ./icons/whitesur.nix { })
      ##(pkgs.callPackage ./gtk/phocus.nix { inherit colors; })
      cinnamon.nemo
      neofetch
      python3
      grim
      pfetch
      lua-language-server
      pamixer
      brightnessctl
      rofi
      mpd
      foot
      mako
      slurp
      waybar
      cava
      ncmpcpp
      xdotool
      mpdris2
      pavucontrol
      feh
      ripgrep
      ueberzug
      wmctrl
      slop
      exa
    ];
  };
}
