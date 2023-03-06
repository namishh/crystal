{ config, pkgs, lib, hyprland, colors, ... }:

{
  programs.waybar =
    with colors;{
      enable = true;
      package = hyprland.packages.${pkgs.system}.waybar-hyprland;
      systemd = {
        enable = false;
        target = "graphical-session.target";
      };
      style = ''
        window#waybar {
          background-color: ${background};
          color: ${foreground};
          border-bottom: none;
        }
        #workspaces {
          background-color: ${mbg};
          margin : 9px 4.5px;
          border-radius : 5px;
        }
        #workspaces button {
          background-color: transparent;
          color: ${foreground};
          transition: all 0.3s ease;
        }

        #workspaces button:hover {
          background-color: ${color8};
          color: ${color4};
          transition: all 0.3s ease;
        }
        #workspaces button.active {
          color: ${color2};
        }

        #custom-launcher {
          background-color: ${mbg};
          margin : 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }
        #custom-power {
          color : ${color1};
          background-color: ${mbg};
          margin : 9px 6.5px 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }

        #clock {
          background-color: ${mbg};
          margin : 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }
        
        #network {
          color : ${color4};
          background-color: ${mbg};
          margin : 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }

        #pulseaudio {
          color : ${color2};
          background-color: ${mbg};
          margin : 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }
        #battery {
          color : ${color5};
          background-color: ${mbg};
          margin : 9px 4.5px;
          padding : 5px 8px;
          border-radius : 5px;
        }
        * {
          font-size: 18px;
          font-family: "Iosevka Nerd Font";
        }
      '';
      settings = [{
        height = 50;
        layer = "top";
        position = "bottom";
        tray = { spacing = 10; };
        modules-center = [ "clock" ];
        modules-left = [ "custom/launcher" "wlr/workspaces" ];
        modules-right = [
          "pulseaudio"
          "network"
          "battery"
          "custom/power"
          "tray"
        ];
        battery = {
          format = "{icon} {capacity}%";
          format-charging = "{  capacity}%";
          format-icons = [ " " " " " " " " " " ];
          format-plugged = "  {capacity}%";
          states = {
            critical = 15;
            warning = 30;
          };
        };
        clock = {
          tooltip-format = "{:%Y-%m-%d | %H:%M}";
        };
        network = {
          interval = 1;
          format-disconnected = "Disconnected";
          format-wifi = "  {essid}";
        };
        "custom/launcher" = {
          on-click = "rofi -show drun";
          format = " ";
        };
        "custom/power" = {
          on-click = "powermenu";
          format = " ";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-bluetooth-muted = "{icon} {volume}%";
          format-icons = {
            car = "";
            default = [ "" "" " " ];
            handsfree = "";
            headphones = "";
            headset = "";
            phone = "";
            portable = "";
          };
          format-muted = " {format_source}";
          on-click = "pavucontrol";
        };
      }];
    };
}
