{ config }:

{
  programs.ncmpcpp = {
    enable = true;
    mpdMusicDir = "${config.home.homeDirectory}/Music";
    settings = {
      # Miscelaneous
      ncmpcpp_directory = "${config.home.homeDirectory}/.config/ncmpcpp";
      ignore_leading_the = true;

      # Visualizer
      visualizer_data_source = "/tmp/mpd.fifo";
      visualizer_output_name = "Visualizer";
      visualizer_in_stereo = true;
      visualizer_type = "ellipse";
      visualizer_look = "●●";
      visualizer_color = "magenta, blue, cyan, green";

      # Appearance
      user_interface = "classic";
      playlist_display_mode = "columns";
      statusbar_visibility = false;
      header_visibility = false;
      titles_visibility = false;
      # progressbar_look          = "▂▂▂";
      progressbar_look = "‎‎‎";
      progressbar_color = "black";
      progressbar_elapsed_color = "yellow";
      song_status_format = "$7%t";
      song_list_format = "  %t $R%a %l  ";
      song_columns_list_format = "(53)[blue]{tr} (45)[white]{a}";
      song_library_format = "{{%a - %t} (%b)} | {%f}";

      # Colors
      main_window_color = "blue";
      current_item_prefix = "$(blue)$r";
      current_item_suffix = "$/r$(end)";
      current_item_inactive_column_prefix = "$(white)";
      current_item_inactive_column_suffix = "$(white)";
      color1 = "white";
      color2 = "red";
    };
  };
}
