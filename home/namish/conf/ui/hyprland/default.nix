{ config, lib, pkgs, hyprland, colors, ... }:

{
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = with colors; {
    enable = true;
    package = hyprland.packages.${pkgs.system}.hyprland;
    systemdIntegration = true;
    extraConfig = ''
      $mainMod = SUPER
      # $scripts=$HOME/.config/hypr/scripts
      monitor=,preferred,auto,1 
      # monitor=HDMI-A-1, 1920x1080, 0x0, 1
      # monitor=eDP-1, 1920x1080, 1920x0, 1
      # Source a file (multi-file configs)
      # source = ~/.config/hypr/myColors.conf
      input {
        kb_layout = us
        kb_variant =
        kb_model =
        kb_options = caps:escape
        kb_rules =
        follow_mouse = 1 # 0|1|2|3
        float_switch_override_focus = 2
        numlock_by_default = true
        touchpad {
        natural_scroll = yes
        }
        sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
      }
      general {
        gaps_in = 8
        gaps_out = 8
        border_size = 3
        col.active_border = rgb(${color4})
        col.inactive_border = rgba(595959aa)
        layout = dwindle # master|dwindle 
      }
      dwindle {
        no_gaps_when_only = false
        force_split = 0 
        special_scale_factor = 0.8
        split_width_multiplier = 1.0 
        use_active_for_splits = true
        pseudotile = yes 
        preserve_split = yes 
      }
      master {
        new_is_master = true
        special_scale_factor = 0.8
        new_is_master = true
        no_gaps_when_only = false
      }
      # cursor_inactive_timeout = 0
      decoration {
        multisample_edges = true
        active_opacity = 1
        inactive_opacity = 1
        fullscreen_opacity = 1.0
        rounding = 6
        drop_shadow = true
        shadow_range = 4
        shadow_render_power = 3
        shadow_ignore_window = true
      # col.shadow = 
      # col.shadow_inactive
      # shadow_offset
        dim_inactive = false
      # dim_strength = #0.0 ~ 1.0
        blur {
          enabled: true
          size = 20
          passes = 4
          new_optimizations = true
        }
      }
      animations {
        enabled=1
        bezier = overshot, 0.13, 0.99, 0.29, 1.1
        animation = windows, 1, 4, overshot, slide
        animation = windowsOut, 1, 5, default, popin 80%
        animation = border, 1, 5, default
        animation = fade, 1, 4, default
        animation = workspaces, 1, 6, overshot, slidevert
      }
      gestures {
        workspace_swipe = true
        workspace_swipe_fingers = 4
        workspace_swipe_distance = 250
        workspace_swipe_invert = true
        workspace_swipe_min_speed_to_force = 15
        workspace_swipe_cancel_ratio = 0.5
        workspace_swipe_create_new = true
      }
      misc {
        disable_autoreload = true
        disable_hyprland_logo = true
        always_follow_on_dnd = true
        layers_hog_keyboard_focus = true
        animate_manual_resizes = false
        enable_swallow = true
        swallow_regex =
        focus_on_activate = true
      }
      device:epic mouse V1 {
        sensitivity = -0.5
      }
      bind = $mainMod, Return, exec, wezterm
      bind = $mainMod SHIFT, Return, exec, wezterm
      bind = $mainMod SHIFT, C, killactive,
      bind = $mainMod SHIFT, Q, exit,
      bind = $mainMod SHIFT, Space, togglefloating,
      bind = $mainMod,F,fullscreen
      bind = $mainMod,Y,pin
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, J, togglesplit, # dwindle
      #-----------------------#
      # Toggle grouped layout #
      #-----------------------#
      bind = $mainMod, K, togglegroup,
      bind = $mainMod, Tab, changegroupactive, f
      #------------#
      # change gap #
      #------------#
      bind = $mainMod SHIFT, G,exec,hyprctl --batch "keyword general:gaps_out 5;keyword general:gaps_in 3"
      bind = $mainMod , G,exec,hyprctl --batch "keyword general:gaps_out 0;keyword general:gaps_in 0"
      #--------------------------------------#
      # Move focus with mainMod + arrow keys #
      #--------------------------------------#
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d
      #----------------------------------------#
      # Switch workspaces with mainMod + [0-9] #
      #----------------------------------------#
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 5, workspace, 5
      bind = $mainMod, 6, workspace, 6
      bind = $mainMod, 7, workspace, 7
      bind = $mainMod, 8, workspace, 8
      bind = $mainMod, 9, workspace, 9
      bind = $mainMod, 0, workspace, 10
      bind = $mainMod, L, workspace, +1
      bind = $mainMod, H, workspace, -1
      bind = $mainMod, period, workspace, e+1
      bind = $mainMod, comma, workspace,e-1
      bind = $mainMod, Q, workspace,QQ
      bind = $mainMod, T, workspace,TG
      bind = $mainMod, M, workspace,Music
      #-------------------------------#
      # special workspace(scratchpad) #
      #-------------------------------# 
      bind = $mainMod, minus, movetoworkspace,special
      bind = $mainMod, equal, togglespecialworkspace
      #----------------------------------#
      # move window in current workspace #
      #----------------------------------#
      bind = $mainMod SHIFT,left ,movewindow, l
      bind = $mainMod SHIFT,right ,movewindow, r
      bind = $mainMod SHIFT,up ,movewindow, u
      bind = $mainMod SHIFT,down ,movewindow, d

      #---------------------------------------------------------------#
      # Move active window to a workspace with mainMod + ctrl + [0-9] #
      #---------------------------------------------------------------#
      bind = $mainMod CTRL, 1, movetoworkspace, 1
      bind = $mainMod CTRL, 2, movetoworkspace, 2
      bind = $mainMod CTRL, 3, movetoworkspace, 3
      bind = $mainMod CTRL, 4, movetoworkspace, 4
      bind = $mainMod CTRL, 5, movetoworkspace, 5
      bind = $mainMod CTRL, 6, movetoworkspace, 6
      bind = $mainMod CTRL, 7, movetoworkspace, 7
      bind = $mainMod CTRL, 8, movetoworkspace, 8
      bind = $mainMod CTRL, 9, movetoworkspace, 9
      bind = $mainMod CTRL, 0, movetoworkspace, 10
      bind = $mainMod CTRL, left, movetoworkspace, -1
      bind = $mainMod CTRL, right, movetoworkspace, +1
      # same as above, but doesnt switch to the workspace
      bind = $mainMod SHIFT, 1, movetoworkspacesilent, 1
      bind = $mainMod SHIFT, 2, movetoworkspacesilent, 2
      bind = $mainMod SHIFT, 3, movetoworkspacesilent, 3
      bind = $mainMod SHIFT, 4, movetoworkspacesilent, 4
      bind = $mainMod SHIFT, 5, movetoworkspacesilent, 5
      bind = $mainMod SHIFT, 6, movetoworkspacesilent, 6
      bind = $mainMod SHIFT, 7, movetoworkspacesilent, 7
      bind = $mainMod SHIFT, 8, movetoworkspacesilent, 8
      bind = $mainMod SHIFT, 9, movetoworkspacesilent, 9
      bind = $mainMod SHIFT, 0, movetoworkspacesilent, 10
      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1
      #-------------------------------------------#
      # switch between current and last workspace #
      #-------------------------------------------#
      binds {
           workspace_back_and_forth = 1 
           allow_workspace_cycles = 1
      }
      bind=$mainMod,slash,workspace,previous
      #------------------------#
      # quickly launch program #
      #------------------------# 
      bind=$mainMod,M,exec,netease-cloud-music-gtk4 
      bind=$mainMod,A,exec, rofi -show drun
      #-----------------------------------------#
      # control volume,brightness,media players-#
      #-----------------------------------------#
      bind=,XF86AudioRaiseVolume,exec, pamixer -i 5
      bind=,XF86AudioLowerVolume,exec, pamixer -d 5
      bind=,XF86AudioMute,exec, pamixer -t
      bind=,XF86AudioMicMute,exec, pamixer --default-source -t
      bind=,XF86MonBrightnessUp,exec, light -A 5
      bind=,XF86MonBrightnessDown, exec, light -U 5
      bind=,XF86AudioPlay,exec, mpc -q toggle 
      bind=,XF86AudioNext,exec, mpc -q next 
      bind=,XF86AudioPrev,exec, mpc -q prev
      #---------------#
      # waybar toggle #
      # --------------#
      bind=$mainMod,O,exec,killall -SIGUSR1 .waybar-wrapped
      #---------------#
      # resize window #
      #---------------#
      bind=ALT,R,submap,resize
      submap=resize
      binde=,right,resizeactive,15 0
      binde=,left,resizeactive,-15 0
      binde=,up,resizeactive,0 -15
      binde=,down,resizeactive,0 15
      binde=,l,resizeactive,15 0
      binde=,h,resizeactive,-15 0
      binde=,k,resizeactive,0 -15
      binde=,j,resizeactive,0 15
      bind=,escape,submap,reset 
      submap=reset
      bind=CTRL SHIFT, left, resizeactive,-15 0
      bind=CTRL SHIFT, right, resizeactive,15 0
      bind=CTRL SHIFT, up, resizeactive,0 -15
      bind=CTRL SHIFT, down, resizeactive,0 15
      bind=CTRL SHIFT, l, resizeactive, 15 0
      bind=CTRL SHIFT, h, resizeactive,-15 0
      bind=CTRL SHIFT, k, resizeactive, 0 -15
      bind=CTRL SHIFT, j, resizeactive, 0 15
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow
      exec = swaybg -i ~/.config/awesome/theme/wallpapers/${name}/${wallpaper} &
      exec = dunst &
      exec-once = xss-lock lock &
      exec-once = eww open bar &
      exec-once = xrdb -merge ~/.Xresources &

      layerrule = blur,lockscreen
      layerrule = blur,gtk-layer-shell
      layerrule = blur,waybar
      #---------------#
      # windows rules #
      #---------------#
      #`hyprctl clients` get class、title...
      windowrule=float,title:^(Picture-in-Picture)$
      windowrule=size 960 540,title:^(Picture-in-Picture)$
      windowrule=move 25%-,title:^(Picture-in-Picture)$
      windowrule=float,imv
      windowrule=move 25%-,imv
      windowrule=size 960 540,imv
      windowrule=float,mpv
      windowrule=move 25%-,mpv
      windowrule=size 960 540,mpv
      windowrule=float,danmufloat
      windowrule=move 25%-,danmufloat
      windowrule=pin,danmufloat
      windowrule=rounding 5,danmufloat
      windowrule=size 960 540,danmufloat
      windowrule=float,termfloat
      windowrule=move 25%-,termfloat
      windowrule=size 960 540,termfloat
      windowrule=rounding 5,termfloat
      windowrule=float,nemo
      windowrule=move 25%-,nemo
      windowrule=size 960 540,nemo
      windowrule=opacity 0.95,title:Telegram
      windowrule=opacity 0.95,title:QQ
      windowrule=opacity 0.95,title:NetEase Cloud Music Gtk4
      windowrule=animation slide right,st
      windowrule=workspace name:QQ, title:Icalingua++
      windowrule=workspace name:TG, title:Telegram
      windowrule=workspace name:Music, title:NetEase Cloud Music Gtk4
      windowrule=workspace name:Music, musicfox
      windowrule=float,ncmpcpp
      windowrule=move 25%-,ncmpcpp
      windowrule=size 960 540,ncmpcpp
      windowrule=noblur,^(firefox)$
    '';
  };
}
