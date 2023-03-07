{ config, pkgs, lib, ... }:


let
  colors = import ./cols/everforest.nix { };
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  swayfx = (import flake-compat {
    src = builtins.fetchTarball "https://github.com/WillPower3309/swayfx/archive/master.tar.gz";
  }).defaultNix;

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

  imports = [
    # Importing Configutations
    (import ./xresources.nix { inherit colors; })
    (import ./conf/utils/rofi/default.nix { inherit config pkgs colors; })
    (import ./conf/utils/dunst/default.nix { inherit config pkgs colors; })
    (import ./conf/shell/zsh/default.nix { inherit config; })
    (import ./conf/music/mpd/default.nix { inherit config; })
    (import ./conf/music/ncmp/default.nix { inherit config; })
    (import ./conf/ui/swayfx/default.nix { inherit config pkgs lib swayfx colors; })
    (import ./conf/ui/eww/default.nix { inherit config pkgs colors lib; })
    (import ./conf/utils/swaylock/default.nix { inherit config pkgs colors; })
    (import ./conf/ui/waybar/default.nix { inherit config pkgs lib colors; })

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
      firefox
      (pkgs.callPackage ./icons/whitesur.nix { })
      #(pkgs.callPackage ./gtk/phocus.nix { inherit colors; })
      cinnamon.nemo
      neofetch
      python3
      grim
      pfetch
      lua-language-server
      pamixer
      brightnessctl
      rofi-wayland
      mpd
      nix-prefetch-git
      git
      slurp
      cava
      ncmpcpp
      xclip
      xdotool
      mpdris2
      pavucontrol
      python310Packages.pip
      feh
      spotdl
      brillo
      ripgrep
      ueberzug
      wmctrl
      slop
      exa
    ];
  };

  systemd.user.services.swaybg =
    let
      wallpaper = builtins.fetchurl rec {
        name = "wallpaper-${sha256}.png";
        url = "${colors.wallpaper}";
        sha256 = "${colors.wallsha}";
      };
    in
    {
      Unit = {
        Description = "Wayland wallpaper daemon";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.swaybg}/bin/swaybg --mode fill --image ${wallpaper}";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
}
