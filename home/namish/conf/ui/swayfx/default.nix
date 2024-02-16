{ config, lib, pkgs, colors, inputs, walltype, ... }:
let
  wall = if colors.name == "material" then "~/.cache/wallpapers/material.jpg" else "~/.wallpapers/${colors.name}.jpg";
  w = if walltype == "image" then "output * bg ${wall} fill" else "output * bg #${colors.color8} solid_color";
in
{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.sway = with colors; {
    enable = true;
    systemd.enable = true;
    xwayland = true;
    package = inputs.swayfx.packages.${pkgs.system}.default;
    extraConfig = ''
      ## SWAYFX CONFIG
      corner_radius 14
      shadows on
      shadow_offset 0 0
      shadow_blur_radius 20
      shadow_color #000000BB
      shadow_inactive_color #000000B0

      default_dim_inactive 0.2

      layer_effects "notif" blur enable; shadows enable; corner_radius 20
      layer_effects "osd" blur enable; shadows enable; corner_radius 20
      layer_effects "work"  shadows enable
      layer_effects "panel" shadows enable
      layer_effects "calendarbox"shadows enable; corner_radius 12

      for_window [app_id="spad"] move scratchpad, resize set width 900 height 600
      for_window [app_id="smusicpad"] move scratchpad, resize set width 850 height 550

      set $bg-color 	         #${mbg}
      set $inactive-bg-color   #${darker}
      set $text-color          #${foreground}
      set $inactive-text-color #${foreground}
      set $urgent-bg-color     #${color9}

      # window colors
      #                       border              background         text                 indicator
      client.focused          $bg-color           $bg-color          $text-color          $bg-color 
      client.unfocused        $inactive-bg-color $inactive-bg-color $inactive-text-color  $inactive-bg-color
      client.focused_inactive $inactive-bg-color $inactive-bg-color $inactive-text-color  $inactive-bg-color
      client.urgent           $urgent-bg-color    $urgent-bg-color   $text-color          $urgent-bg-color

      font pango:Product Sans 12
      titlebar_separator enable
      titlebar_padding 16
      title_align center
      default_border normal 2
      default_floating_border normal 2

      exec_always --no-startup-id xrdb -merge ~/.Xresources &
      exec --no-startup-id ags &
      exec_always --no-startup-id mpDris2 &
      exec_always --no-startup-id autotiling-rs &
      exec --no-startup-id swayidle -w \
          timeout 360 'waylock' \
          timeout 600 'swaymsg "output * power off"' resume 'swaymsg "output * power on"' \
          before-sleep 'waylock'
    '';
    config = {
      terminal = "wezterm";
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
          "print" = "exec 'grim -g \"$(slurp)\" - | wl-copy'";
          "Shift+print" = "exec 'grim - | wl-copy'";

          "XF86MonBrightnessUp" = "exec 'brightnessctl s 5+'";
          "XF86MonBrightnessDown" = "exec 'brightnessctl s 5-'";

          "XF86AudioRaiseVolume" = "exec 'pamixer -u ; pamixer -i 5'";
          "XF86AudioLowerVolume" = "exec 'pamixer -u ; pamixer -d 5'";
          "XF86AudioMute" = "exec 'pamixer -t'";

          "${mod}+Return" = "exec ${cfg.terminal}";
          "${mod}+Shift+q" = "reload";
          "${mod}+Shift+s" = "exec 'pkill ags ; ags & disown'";
          "${mod}+d" = "exec ${cfg.menu}";

          "${mod}+v" = "exec 'swayscratch spad'";
          "${mod}+z" = "exec 'swayscratch smusicpad'";
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

          "${mod}+Shift+b" = "splith";
          "${mod}+Shift+v" = "splitv";
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
          xkb_options = "grp:win_space_toggle,compose:ralt";
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
      bars = [
      ];
    };
  };
}
