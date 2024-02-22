{ colors }:

with colors; {
  xresources = {
    path = ".Xresources";
    extraConfig = ''
    '';
    properties = {
      "st.background" = "#${background}";
      "st.alt" = "#${mbg}";
      "st.color0" = "#${color0}";
      "st.color8" = "#${color8}";
      "st.color7" = "#${color7}";
      "st.color15" = "#${color15}";
      "st.foreground" = "#${foreground}";
      "st.color1" = "#${color1}";
      "st.color9" = "#${color9}";
      "st.color2" = "#${color2}";
      "st.color10" = "#${color10}";
      "st.color3" = "#${color3}";
      "st.color11" = "#${color11}";
      "st.color4" = "#${color4}";
      "st.color12" = "#${color12}";
      "st.color5" = "#${color5}";
      "st.color13" = "#${color13}";
      "st.color6" = "#${color6}";
      "st.color14" = "#${color14}";
      "st.borderpx" = 32;
      "dwm.normbgcolor" = "#${darker}";
      "dwm.normfgcolor" = "#${foreground}";
      "dwm.normbordercolor" = "#${comment}";
      "dwm.selbgcolor" = "#${mbg}";
      "dwm.selfgcolor" = "#${accent}";
      "dwm.selbordercolor" = "#${accent}";
      "dwm.urgcolor" = "#${color9}";
    };
  };
}

