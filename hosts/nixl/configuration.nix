{ inputs, config, pkgs, lib, self, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ../shared
  ];
  networking.hostName = "nixl";

  # Packages
  # --------
  boot.kernelPackages = pkgs.linuxPackages_5_10;
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      brightnessctl
      wayland;
  };

  services = {
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
