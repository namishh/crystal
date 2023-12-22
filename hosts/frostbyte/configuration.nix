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
      (final: prev:
        {
          awesome = inputs.nixpkgs-f2k.packages.${pkgs.system}.awesome-git;
        })
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

  networking.hostName = "frostbyte";
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
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          middleEmulation = true;
          naturalScrolling = true;
        };
      };
      displayManager = {
        defaultSession = "none+awesome";
        startx.enable = true;
      };
      windowManager.awesome = {
        enable = true;
      };
      desktopManager.gnome.enable = false;
    };
  };
}
