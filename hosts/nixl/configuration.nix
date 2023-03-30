{ inputs, outputs, config, pkgs, lib, self, ... }:
{

  imports = [
    ./hardware-configuration.nix
    ../shared
    ../../services/picom.nix
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
          picom = inputs.nixpkgs-f2k.packages.${pkgs.system}.picom-git;
        })
    ];
    config = {
      # Disable if you don't want unfree packages
      allowUnfreePredicate = _: true;
      allowUnfree = true;
    };
  };
  networking.hostName = "nixl";
  networking.useDHCP = false;
  networking.interfaces.wlo1.useDHCP = true;
  # Packages
  # --------
  boot.kernelPackages = pkgs.linuxPackages_5_15;
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      brightnessctl
      wayland;
  };

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
        luaModules = with pkgs.luaPackages; [
          lgi
      ];

      };
      desktopManager.gnome.enable = false;
    };
  };
  

}
