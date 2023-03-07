{ config, pkgs, colors }:

with colors;{

  services.dunst = {
    enable = true;
    package = pkgs.dunst.overrideAttrs (oldAttrs: {
      src = pkgs.fetchFromGitHub {
        owner = "k-vernooy";
        repo = "dunst";
        rev = "61567d58855ba872f8237861ddcd786d03dd2631";
        sha256 = "ttaaomjb3CclZG9JPdzDBj5XXlqRaKGPBY3ahFofqVM=";
      };
    });

    settings = {
      global = {
        follow = "mouse";
        width = 300;
        origin = "top-right";
        alignment = "left";
        vertical_alignment = "center";
        ellipsize = "middle";
        offset = "15x15";
        padding = 15;
        horizontal_padding = 15;
        text_icon_padding = 15;
        icon_position = "left";
        min_icon_size = 48;
        max_icon_size = 64;
        progress_bar = true;
        progress_bar_height = 12;
        progress_bar_frame_width = 1;
        progress_bar_min_width = 150;
        progress_bar_max_width = 300;
        separator_height = 2;
        frame_width = 2;
        frame_color = "#${mbg}";
        separator_color = "frame";
        corner_radius = 3;
        transparency = 0;
        gap_size = 8;
        line_height = 0;
        notification_limit = 0;
        idle_threshold = 120;
        history_length = 20;
        show_age_threshold = 60;
        markup = "full";
        font = "Iosevka Nerd Font 10";
        format = "<span size='x-large' font_desc='Iosevka Nerd Font 10' weight='bold' foreground='#${foreground}'>%s</span>\\n%b";
        word_wrap = "yes";
        sort = "yes";
        shrink = "no";
        indicate_hidden = "yes";
        sticky_history = "yes";
        ignore_newline = "no";
        show_indicators = "no";
        stack_duplicates = true;
        always_run_script = true;
        hide_duplicate_count = false;
        ignore_dbusclose = false;
        force_xwayland = false;
        force_xinerama = false;
        mouse_left_click = "do_action";
        mouse_middle_click = "close_all";
        mouse_right_click = "close_current";
      };

      fullscreen_delay_everything = { fullscreen = "delay"; };

      urgency_low = {
        timeout = 3;
        background = "#${background}";
        foreground = "#${foreground}";
        highlight = "#${color4}";
      };
      urgency_normal = {
        timeout = 6;
        background = "#${background}";
        foreground = "#${foreground}";
        highlight = "#${color2}";
      };
      urgency_critical = {
        timeout = 0;
        background = "#${background}";
        foreground = "#${foreground}";
        highlight = "#${color1}";
      };
    };
  };
}
