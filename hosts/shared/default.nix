{ pkgs, outputs, overlays, lib, ... }:
let
  flake-compat = builtins.fetchTarball "https://github.com/edolstra/flake-compat/archive/master.tar.gz";

in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  networking = {
    networkmanager.enable = true;
    firewall.enable = true;
  };

  security = {
    sudo.enable = true;
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
  fonts.fonts = with pkgs; [
    material-design-icons
    inter
    rubik
    ibm-plex
    (nerdfonts.override { fonts = [ "Iosevka" "CascadiaCode" "JetBrainsMono" ]; })
  ];

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.extraConfig = "load-module module-native-protocol-tcp auth-ip-acl=127.0.0.1";
  security.rtkit.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").overlays.default
    outputs.overlays.modifications
    outputs.overlays.additions
  ];
  environment.systemPackages = with pkgs; [
    nodejs
    libnotify
    xdg-utils
    jq
    st-custom
    (builtins.getFlake "github:fortuneteller2k/nixpkgs-f2k").packages.${system}.awesome-git
    git
    mpv
    slurp
    xdotool
    simplescreenrecorder
    brightnessctl
    pamixer
    nix-prefetch-git
    python3
    brillo
    wmctrl
    slop
    ueberzug
    ripgrep
    maim
    xclip
    wirelesstools
    xorg.xf86inputevdev
    xorg.xf86inputsynaptics
    xorg.xf86inputlibinput
    xorg.xorgserver
    xorg.xf86videoati
  ];

  environment.shells = with pkgs; [ zsh ];

  programs.dconf.enable = true;
  qt = {
    enable = true;
    platformTheme = "gtk2";
    style = "gtk2";
  };

  # Fonts

  # Hardware
  # --------
  # CUPS support
  services.printing.enable = true;
  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  security.polkit.enable = true;
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
      warn-dirty = false;
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
