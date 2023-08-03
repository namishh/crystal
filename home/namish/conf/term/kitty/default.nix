{ pkgs, colors, ... }:

with colors; {
  programs.kitty = {
    enable = true;
    settings = {
      font_family = "Iosevka Nerd Font";
      italic_font = "auto";
      bold_font = "auto";
      bold_italic_font = "auto";
      font_size = 16;
      disable_ligatures = "never";
      confirm_os_window_close = 0;
      window_padding_width = 24;
      adjust_line_height = 0;
      adjust_column_width = 0;
      box_drawing_scale = "0.01, 0.8, 1.5, 2";
      mouse_hide_wait = 0;
      focus_follows_mouse = "no";

      # Performance
      repaint_delay = 20;
      input_delay = 2;
      sync_to_monitor = "no";

      # Bell
      visual_bell_duration = 0;
      enable_audio_bell = "no";
      bell_on_tab = "yes";

    };
    extraConfig = ''
      modify_font cell_height 120%
      click_interval 0.5
      cursor_blink_interval 0
      modify_font cell_width 87%
      background #${colors.background}
      foreground #${colors.foreground}
      cursor     #${colors.foreground}

      # Black
      color0 #${colors.color0}
      color8 #${colors.color0}

      # Red
      color1 #${colors.color1}
      color9 #${colors.color9}

      # Green
      color2 #${colors.color2}
      color10 #${colors.color10}

      # Yellow
      color3  #${colors.color3}
      color11 #${colors.color11}

      # Blue
      color4 #${colors.color4}
      color12 #${colors.color12}

      # Magenta
      color5 #${colors.color5}
      color13 #${colors.color13}

      # Cyan
      color6 #${colors.color6}
      color14 #${colors.color14}
      # White
      color7 #${colors.color7}
      color15 #${colors.color15}

    '';
  };
}
