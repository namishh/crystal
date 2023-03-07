{ inputs, config, pkgs, lib, self, xdg-hyprland, ... }:

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

  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };

  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    upower.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      displayManager = {
        defaultSession = "gnome";
        startx.enable = true;
      };
      desktopManager.gnome.enable = true;
    };
  };

}
