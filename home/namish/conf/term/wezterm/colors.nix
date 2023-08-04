{ colors, ... }:

with colors; {
  followSystem = {
    # basic colors
    background = "#${background}";
    cursor_bg = "#${foreground}";
    cursor_border = "#${foreground}";
    cursor_fg = "#${color8}";
    foreground = "#${foreground}";
    selection_bg = "#${color15}";
    selection_fg = "#${background}";
    split = "#${mbg}";

    # base16
    ansi = [
      "#${color0}"
      "#${color1}"
      "#${color2}"
      "#${color3}"
      "#${color4}"
      "#${color5}"
      "#${color6}"
      "#${color7}"
    ];
    brights = [
      "#${color8}"
      "#${color9}"
      "#${color10}"
      "#${color11}"
      "#${color12}"
      "#${color13}"
      "#${color14}"
      "#${color15}"
    ];

    # tabbar
    tab_bar = {
      background = "#${color8}";
      active_tab = {
        bg_color = "#${background}";
        fg_color = "#${foreground}";
      };
      inactive_tab = {
        bg_color = "#${color8}";
        fg_color = "#${foreground}";
      };
      inactive_tab_hover = {
        bg_color = "#${color0}";
        fg_color = "#${foreground}";
      };
      inactive_tab_edge = "#${color0}";
      new_tab = {
        bg_color = "#${color8}";
        fg_color = "#${color7}";
      };
      new_tab_hover = {
        bg_color = "#${color0}";
        fg_color = "#${foreground}";
      };
    };
  };
}
