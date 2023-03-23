{ config, pkgs, lib, ... }:

{
  systemd.user.services.killPicom = {
    enable = true;
    wantedBy = [ "suspend.target" ];
    before = [ "suspend.target" ];
    description = "Kill Picom";
    serviceConfig = {
      Type = "simple";
      User = "namish";
      ExecStart = ''pkill picom'';
      ExecStartPost = ''sleep 1'';
    };
  };

}

