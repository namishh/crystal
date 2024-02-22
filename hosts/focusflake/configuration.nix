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
      windowManager.dwm = {
        enable = true;
        package = pkgs.dwm.override {
          conf = ../../patches/dwm/config.def.h;
          patches = [
            # IN THE NAME OF THY GOD,
            # DO NOT CHANGE THE ORDER OF THESE PATCHES 
            # OR SHIT WILL BREAK
            ../../patches/dwm/alt-tags.diff
            ../../patches/dwm/awm.diff
            ../../patches/dwm/fullscreen.diff
            ../../patches/dwm/systray.diff
            ../../patches/dwm/scratches.diff
            ../../patches/dwm/alttab.diff
            ../../patches/dwm/restartsig.diff
            ../../patches/dwm/restore.diff
            ../../patches/dwm/autostart.diff
            ../../patches/dwm/center.diff
            ../../patches/dwm/statuspadding.diff
            ../../patches/dwm/swallow.diff
            ../../patches/dwm/xresources.diff
            ../../patches/dwm/urgentbor.diff
            ../../patches/dwm/fullgaps.diff
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
