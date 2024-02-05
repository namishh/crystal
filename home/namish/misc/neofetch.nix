{ config, colors }:

{
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        prin ""
        info title
        info "\e[34m  " os
        info "\e[31m " kernel
        info "\e[33m " uptime
        info "\e[32m " shell
        info "\e[35m " wm
        prin "$(color 1)▂▂ $(color 2)▂▂ $(color 3)▂▂ $(color 4)▂▂ $(color 5)▂▂ $(color 6)▂▂ "
    }

    title_fqdn="off"
    kernel_shorthand="on"
    distro_shorthand="off"
    uptime_shorthand="tiny"
    memory_percent="off"
    memory_unit="mib"
    package_managers="off"
    shell_path="off"
    shell_version="on"
    speed_type="bios_limit"
    speed_shorthand="off"
    cpu_brand="on"
    cpu_cores="logical"
    refresh_rate="off"
    gtk_shorthand="off"
    gtk2="on"
    gtk3="on"
    de_version="on"
    bold="off"
    underline_enabled="on"
    underline_char="_"
    separator=" • "
    color_blocks="on"
    block_width=3
    block_height=1
    col_offset="auto"
    bar_char_elapsed="-"
    bar_char_total="="
    bar_border="on"
    bar_length=15
    bar_color_elapsed="distro"
    bar_color_total="distro"
    image_backend="kitty"
    image_source="/etc/nixos/home/images/misc/neofetch.png"
    image_size="250px"
    image_loop="on"
    ascii_distro="nixos"
    ascii_colors=(distro)
    ascii_bold="on"
    thumbnail_dir="${config.home.homeDirectory}/.cache/thumbnails/neofetch"
    crop_mode="fit"
    crop_offset="center"
    yoffset=0
    xoffset=0
    stdout="off"

  '';
}


