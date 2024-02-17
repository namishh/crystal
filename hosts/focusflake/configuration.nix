{ inputs, outputs, config, pkgs, lib, self, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../shared
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.modifications
      outputs.overlays.additions
      inputs.nixpkgs-f2k.overlays.stdenvs
      inputs.nixpkgs-f2k.overlays.compositors
      inputs.nur.overlay
    ];
    config = {
      allowUnfreePredicate = _: true;
      allowUnfree = true;
    };
  };

  # fuck you jio
  networking.extraHosts =
    ''
      185.199.108.133 raw.githubusercontent.com
    '';

  networking.hostName = "focusflake";
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;

  boot.kernelPackages = pkgs.linuxPackages_5_15;

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
    thunar = {
      enable = true;
      plugins = with pkgs.xfce; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
  };

  services = {
    gvfs.enable = true;
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    upower.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      displayManager = {
        startx.enable = true;
      };
      desktopManager.xfce.enable = true;
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override {
          conf = ../../patches/dwm/config.def.h;
          patches = [
            ../../patches/dwm/systray.diff
            ../../patches/dwm/xresources.diff
            ../../patches/dwm/alt-tags.diff
            ../../patches/dwm/fullgaps.diff
            ../../patches/dwm/titlecolor.diff
            ../../patches/dwm/barheight.diff
          ];
        };
      };
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = true;
          naturalScrolling = true;
        };
      };
    };
  };
}
