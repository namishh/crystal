{ colors }:
{

  home.file.".config/cava/config".text = ''
    [general]
    bar_width = 1
    bar_spacing = 0
    [color]

    # ncurses output method and a terminal that can change color definitions such as Gnome-terminal or rxvt.
    # if supported, ncurses mode will be forced on if user defined colors are used.
    # default is to keep current terminal color
    ;background = default
    ;foreground = default
    # SDL only support hex code colors, these are the default:
    ;background = '#111111'
    ; foreground = '#33cccc'
    # Gradient mode, only hex defined colors (and thereby ncurses mode) are supported,
    # background must also be defined in hex  or remain commented out. 1 = on, 0 = off.
    # You can define as many as 8 different colors. They range from bottom to top of screen
    gradient = 1
    gradient_count = 3
    gradient_color_1 = '#${colors.color4}'
    gradient_color_2 = '#${colors.color5}'
    gradient_color_3 = '#${colors.color1}'


  '';
}


