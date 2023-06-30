{ pkgs, colors }:
{
  home.file.".config/kitty/kitty.conf".text = ''
    font_family      Iosevka Nerd Font
    italic_font      auto
    bold_font        auto
    bold_italic_font auto
    font_size        16.0
    disable_ligatures never
    confirm_os_window_close 0
    modify_font cell_height 110%,
    modify_font cell_width 90%
    window_padding_width 32
    adjust_line_height 						0
    adjust_column_width 					0
    box_drawing_scale 						0.01, 0.8, 1.5, 2

    # Cursor
    cursor_shape     							underline
    cursor_blink_interval     					0
    cursor_stop_blinking_after 			15.0

    # Scrollback
    scrollback_lines 							10000
    wheel_scroll_multiplier 					5.0

    # URLs
    url_style 										double
    open_url_modifiers 						ctrl+shift
    open_url_with 								default
    copy_on_select 								yes

    # Selection
    rectangle_select_modifiers 			ctrl+shift
    select_by_word_characters 			:@-./_~?&=%+#

    # Mouse
    click_interval 								0.5
    mouse_hide_wait 							0
    focus_follows_mouse 					no

    # Performance
    repaint_delay    							20
    input_delay 									2
    sync_to_monitor 							no

    # Bell
    visual_bell_duration 						0.0
    enable_audio_bell 							yes
    bell_on_tab									yes

    # Window
    remember_window_size   				no
    initial_window_width   					700
    initial_window_height  					400
    window_border_width 					0
    window_margin_width 					12
    window_padding_width 					10
    inactive_text_alpha 						1.0
    background_opacity 						1
    placement_strategy 						center
    hide_window_decorations 				yes

    # Layouts
    enabled_layouts 							*

    # Tabs
    tab_bar_edge 								bottom
    tab_bar_style 								powerline
    tab_bar_margin_width 					0.0
    tab_separator 								" ┇ "
    active_tab_font_style 					bold
    inactive_tab_font_style 					normal

    # Shell
    shell 											.
    close_on_child_death 					no
    allow_remote_control 					yes
    term 											xterm-kitty

    # Keys
    map ctrl+shift+v        					paste_from_clipboard
    map ctrl+shift+s        					paste_from_selection
    map ctrl+shift+c        					copy_to_clipboard
    map shift+insert					        paste_from_selection

    map ctrl+shift+up        					scroll_line_up
    map ctrl+shift+down      				scroll_line_down
    map ctrl+shift+k         					scroll_line_up
    map ctrl+shift+j         					scroll_line_down
    map ctrl+shift+page_up   				scroll_page_up
    map ctrl+shift+page_down 			scroll_page_down
    map ctrl+shift+home      				scroll_home
    map ctrl+shift+end       				scroll_end
    map ctrl+shift+h         					show_scrollback

    map ctrl+shift+enter    					new_window
    map ctrl+shift+n        					new_os_window					
    map ctrl+shift+w        					close_window
    map ctrl+shift+]        					next_window
    map ctrl+shift+[        					previous_window
    map ctrl+shift+f        					move_window_forward
    map ctrl+shift+b        					move_window_backward
    map ctrl+shift+`        					move_window_to_top
    map ctrl+shift+1        					first_window
    map ctrl+shift+2        					second_window
    map ctrl+shift+3        					third_window
    map ctrl+shift+4        					fourth_window
    map ctrl+shift+5        					fifth_window
    map ctrl+shift+6        					sixth_window
    map ctrl+shift+7        					seventh_window
    map ctrl+shift+8        					eighth_window
    map ctrl+shift+9        					ninth_window
    map ctrl+shift+0        					tenth_window

    map ctrl+shift+right    					next_tab
    map ctrl+shift+left     					previous_tab
    map ctrl+shift+t        					new_tab
    map ctrl+shift+q        					close_tab
    map ctrl+shift+l        					next_layout
    map ctrl+shift+.        					move_tab_forward
    map ctrl+shift+,        					move_tab_backward
    map ctrl+shift+alt+t    					set_tab_title

    map ctrl+shift+equal    					increase_font_size
    map ctrl+shift+minus    				decrease_font_size
    map ctrl+shift+backspace 			restore_font_size
    map ctrl+shift+f6     						set_font_size 16.0
    background 						#${colors.background}
    foreground 						#${colors.foreground}
    cursor     							#${colors.foreground}

    # Black
    color0								#${colors.color0}
    color8								#${colors.color0}

    # Red
    color1								#${colors.color1}
    color9								#${colors.color9}

    # Green
    color2								#${colors.color2}
    color10								#${colors.color10}

    # Yellow
    color3								#${colors.color3}
    color11								#${colors.color11}

    # Blue
    color4								#${colors.color4}
    color12								#${colors.color12}

    # Magenta
    color5								#${colors.color5}
    color13								#${colors.color13}

    # Cyan
    color6								#${colors.color6}
    color14								#${colors.color14}
    # White
    color7								#${colors.color7}
    color15								#${colors.color15}

  '';
}


