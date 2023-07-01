{ config, colors }:

{
  home.file.".config/neofetch/config.conf".text = ''
    print_info() {
        info title
        prin "\033[0m┌──────────────────────────────────────┐"
        prin "\n"
        info "\n \n \e[32m " os
        info "\n \n \e[31m " kernel
        info "\n \n \e[33m " uptime
        info "\n \n \e[34m " packages
        info "\n \n \e[35m " wm
        info "\n \n \e[32m " shell
        prin "\n"
        prin "\033[0m└───────────────────── \033[0m \033[1;31m \033[1;32m \033[1;33m \033[1;34m \033[1;35m \033[1;36m \033[1;37m \033[0m┘"
        prin "Hello! Have A Nice Day!"
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
    image_source="${config.home.homeDirectory}/.config/awesome/theme/pics/neofetch-pics-and-stuff/${colors.neofetchpic}"
    image_size="400px"
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


