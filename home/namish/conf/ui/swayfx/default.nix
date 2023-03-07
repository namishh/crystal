{ config, lib, pkgs, swayfx, colors, ... }:

{
  programs = {
    zsh = {
      initExtra = ''
        if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
           exec sway
        fi
      '';
    };
  };
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.sway = with colors; {
    enable = true;
    systemdIntegration = true;
    package = swayfx.packages.${pkgs.system}.swayfx-unwrapped;
    extraConfig = ''
      exec_always --no-startup-id xrdb -merge ~/.Xresources &
      exec_always --no-startup-id pkill waybar;waybar &

      ## SWAYFX CONFIG
      corner_radius 5
    '';
    config = {
      terminal = "st";
      menu = "rofi -show drun";
      modifier = "Mod4";

      keycodebindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
          left = "43"; # h
          down = "44"; # j
          up = "45"; # k
          right = "46"; # l
        in
        {
          "${mod}+${left}" = "focus left";
          "${mod}+${down}" = "focus down";
          "${mod}+${up}" = "focus up";
          "${mod}+${right}" = "focus right";

          "${mod}+Shift+${left}" = "move left";
          "${mod}+Shift+${down}" = "move down";
          "${mod}+Shift+${up}" = "move up";
          "${mod}+Shift+${right}" = "move right";
        };

      keybindings =
        let
          cfg = config.wayland.windowManager.sway.config;
          mod = cfg.modifier;
        in
        {

          "XF86MonBrightnessUp" = "~/.local/bin/changebrightness up";
          "XF86MonBrightnessDown" = "~/.local/bin/changebrightness down";

          "XF86AudioRaiseVolume" = "~/.local/bin/changevolume up";
          "XF86AudioLowerVolume" = "~/.local/bin/changevolume down";
          "XF86AudioMute" = "~/.local/bin/changevolume mute";

          "${mod}+Return" = "exec ${cfg.terminal}";
          "${mod}+Shift+q" = "reload";
          "${mod}+d" = "exec ${cfg.menu}";

          #"${mod}+${cfg.left}" = "focus left";
          #"${mod}+${cfg.down}" = "focus down";
          #"${mod}+${cfg.up}" = "focus up";
          #"${mod}+${cfg.right}" = "focus right";

          "${mod}+Left" = "focus left";
          "${mod}+Down" = "focus down";
          "${mod}+Up" = "focus up";
          "${mod}+Right" = "focus right";

          #"${mod}+Shift+${cfg.left}" = "move left";
          #"${mod}+Shift+${cfg.down}" = "move down";
          #"${mod}+Shift+${cfg.up}" = "move up";
          #"${mod}+Shift+${cfg.right}" = "move right";

          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+b" = "splith";
          "${mod}+v" = "splitv";
          "${mod}+f" = "fullscreen";
          "${mod}+a" = "focus parent";

          "${mod}+s" = "layout stacking";
          "${mod}+w" = "layout tabbed";
          "${mod}+e" = "layout toggle split";

          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";

          "${mod}+1" = "workspace number 1";
          "${mod}+2" = "workspace number 2";
          "${mod}+3" = "workspace number 3";
          "${mod}+4" = "workspace number 4";
          "${mod}+5" = "workspace number 5";
          "${mod}+6" = "workspace number 6";
          "${mod}+7" = "workspace number 7";
          "${mod}+8" = "workspace number 8";
          "${mod}+9" = "workspace number 9";
          "${mod}+0" = "workspace number 10";

          "${mod}+Shift+1" = "move container to workspace number 1";
          "${mod}+Shift+2" = "move container to workspace number 2";
          "${mod}+Shift+3" = "move container to workspace number 3";
          "${mod}+Shift+4" = "move container to workspace number 4";
          "${mod}+Shift+5" = "move container to workspace number 5";
          "${mod}+Shift+6" = "move container to workspace number 6";
          "${mod}+Shift+7" = "move container to workspace number 7";
          "${mod}+Shift+8" = "move container to workspace number 8";
          "${mod}+Shift+9" = "move container to workspace number 9";
          "${mod}+Shift+0" = "move container to workspace number 10";

          "${mod}+Shift+minus" = "move scratchpad";
          "${mod}+minus" = "scratchpad show";

          "${mod}+Shift+c" = "kill";
          "${mod}+Shift+e" =
            "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";

          "${mod}+r" = "mode resize";
        };
      input = {
        "type:touchpad" = {
          tap = "enabled";
          natural_scroll = "enabled";
        };
        "*" = {
          xkb_layout = "us";
          xkb_variant = "altgr-intl,dhm-altgr-intl";
          xkb_options = "grp:win_space_toggle,grp_led:caps,ctrl:nocaps,compose:ralt";
        };
      };
      output = {
        "DVI-D-1" = {
          resolution = "1920x1080";
          position = "0,0";
        };
        "HDMI-A-1" = {
          resolution = "1920x1080";
          position = "1920,0";
        };
      };

      gaps = {
        bottom = 5;
        horizontal = 5;
        vertical = 5;
        inner = 5;
        left = 5;
        outer = 5;
        right = 5;
        top = 5;
        smartBorders = "off";
        smartGaps = false;
      };

      window = {
        titlebar = false;
      };

      bars = [
      ];
    };
  };
}
