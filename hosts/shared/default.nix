{ pkgs, outputs, overlays, lib, inputs, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
  my-python-packages = ps: with ps; [
    material-color-utilities
    numpy
    i3ipc
  ];
in
{
  boot.loader = {
    systemd-boot.enable = false;
    grub.enable = true;
    grub.efiSupport = true;
    grub.device = "nodev";
    grub.darkmatter-theme = {
      enable = true;
      style = "nixos";
    };
  };
  hardware.opengl.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  programs.zsh.enable = true;
  programs.nix-ld.enable = true;
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  security.sudo.enable = true;
  services.blueman.enable = true;
  location.provider = "geoclue2";

  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "1";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Asia/Kolkata";
  };

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  users = {
    users.namish = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" "audio" "video" "libvirtd" ];
      packages = with pkgs; [ ];
    };
    defaultUserShell = pkgs.zsh;
  };

  sound.enable = true;

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    extraConfig = "load-module module-switch-on-connect";
  };

  hardware.bluetooth = {
    enable = true;
    settings.General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
    powerOnBoot = true;
  };

  systemd.services.bluetooth.serviceConfig.ExecStart = [
    ""
    "${pkgs.bluez}/libexec/bluetooth/bluetoothd -f /etc/bluetooth/main.conf"
  ];

  security.rtkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };
  services.dbus.enable = true;
  programs.steam.enable = true;
  environment.systemPackages = with pkgs; [
    nodejs
    lutgen
    home-manager
    lua-language-server
    bluez
    direnv
    unzip
    bluez-tools
    inotify-tools
    udiskie
    rnix-lsp
    xorg.xwininfo
    brightnessctl
    (pkgs.python311.withPackages my-python-packages)
    libnotify
    xdg-utils
    gtk3
    niv
    st
    appimage-run
    jq
    spotdl
    osu-lazer
    imgclr
    grim
    slop
    eww-wayland
    swaylock-effects
    git
    pstree
    mpv
    xdotool
    spotify
    simplescreenrecorder
    brightnessctl
    pamixer
    nix-prefetch-git
    python3
    brillo
    wmctrl
    slop
    ripgrep
    imv
    maim
    xclip
    wirelesstools
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xorgserver
    xorg.xf86videoati
  ];

  fonts.packages = with pkgs; [
    material-design-icons
    dosis
    material-symbols
    rubik
    google-fonts
    (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  environment.shells = with pkgs; [ zsh ];
  programs.dconf.enable = true;

  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  services.printing.enable = true;

  services.xserver = {
    layout = "us";
    xkbVariant = "us,";
  };

  security.polkit.enable = true;

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;
      substituters = [ "https://nix-gaming.cachix.org" ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 5d";
    };
    optimise.automatic = true;
  };

  system = {
    copySystemConfiguration = false;
    stateVersion = "22.11";
  };
}
