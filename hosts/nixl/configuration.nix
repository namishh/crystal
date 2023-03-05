{ inputs, config, pkgs, lib, self, xdg-hyprland, ... }:

{

  imports = [
    ./hardware-configuration.nix
    ../shared
  ];
  networking.hostName = "nixl";

  # Packages
  # --------
  boot.kernelPackages = pkgs.linuxPackages;
  environment.systemPackages = lib.attrValues {
    inherit (pkgs)
      brightnessctl;
  };
  # Power
  # -----
  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = true;
    upower.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      displayManager = {
        defaultSession = "gnome";
        sessionPackages = [ inputs.hyprland.packages.${pkgs.system}.default ];

        startx.enable = true;
      };
      desktopManager.gnome.enable = true;
    };
  };

}
