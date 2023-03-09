local theme      = {}
local xresources = require("beautiful.xresources")
local awful      = require("awful")
local dpi        = xresources.apply_dpi
local gfs        = require("gears.filesystem")
local gears      = require("gears")
local reader     = require("modules.read")
local theme_path = gfs.get_configuration_dir() .. "/theme/"
theme.barfont    = 'Iosevka Nerd Font 13'
theme.font       = 'Iosevka Nerd Font'
theme.icofont    = 'Material Design Icons Desktop'


theme.barDir       = reader.readall('bartype') or 'left'
theme.titlebarType = reader.readall('titlebar') or 'vert'
theme.scheme       = reader.readall('theme') or 'gruvbox'
local colors       = require("theme.palettes." .. theme.scheme)

theme.setTheme     = function()
  awful.spawn.with_shell('xrdb -remove')
  awful.spawn.with_shell('xrdb -merge ~/.palettes/' .. colors.name .. " && kill -USR1 $(pidof st)")
  awful.spawn.with_shell('cp ~/.config/rofi/colors/' .. colors.name .. '.rasi ~/.config/rofi/colors.rasi')
  awful.spawn.with_shell("sed -i '2s/.*/gtk-theme-name=" .. colors.gtk .. "/g' ~/.config/gtk-3.0/settings.ini")
end


theme.br                 = dpi(2)

theme.scrheight          = 1080
theme.scrwidth           = 1920

theme.wall               = theme_path .. "wallpapers/" .. colors.wall

theme.ok                 = colors.ok
theme.warn               = colors.warn
theme.err                = colors.err
theme.pri                = colors.pri
theme.dis                = colors.dis

theme.bg                 = colors.bg
theme.mbg                = colors.mbg
theme.bg2                = colors.bg2
theme.bg3                = colors.bg3
theme.bg4                = colors.bg4

theme.fg                 = colors.fg
theme.fg1                = colors.fg2
theme.fg2                = colors.fg3
theme.fg3                = colors.fg4

theme.fg_focus           = theme.fg
theme.fg_normal          = theme.fg1
theme.fg_minimize        = theme.fg2

theme.bg_normal          = theme.bg2
theme.bg_urgent          = theme.err .. "40"
theme.bg_minimize        = theme.fg .. "10"
theme.bg_focus           = theme.fg2 .. "cc"

theme.useless_gap        = dpi(3)
theme.snap_bg            = theme.fg2

theme.border_width       = dpi(5)
theme.border_color       = theme.bg2

theme.titlebar_fg        = theme.fg .. "40"
theme.titlebar_fg_normal = theme.fg2
theme.titlebar_fg_focus  = theme.fg
theme.titlebar_bg        = theme.bg2
theme.titlebar_bg_normal = theme.bg
theme.titlebar_font      = theme.font


theme.taglist_bg               = theme.bg .. "00"
theme.taglist_bg_focus         = theme.pri
theme.taglist_fg_focus         = theme.accent
theme.taglist_bg_urgent        = theme.err
theme.taglist_fg_urgent        = theme.fg
theme.taglist_bg_occupied      = theme.fg2
theme.taglist_fg_occupied      = theme.fg
theme.taglist_bg_empty         = theme.fg3 .. '33'
theme.taglist_fg_empty         = theme.fg
theme.taglist_disable_icon     = true

theme.tasklist_bg_normal       = theme.bg
theme.tasklist_bg_focus        = theme.bg2
theme.tasklist_bg_minimize     = theme.bg3

theme.menu_bg_normal           = theme.bg
theme.menu_fg_normal           = theme.fg1
theme.menu_bg_focus            = theme.bg2
theme.menu_fg_focus            = theme.fg
theme.menu_font                = theme.font
theme.menu_border_color        = theme.bg
theme.menu_height              = dpi(30)
theme.menu_width               = dpi(130)
theme.menu_border_width        = dpi(10)
theme.menu_submenu_icon        = theme_path .. "icons/" .. "menu.svg"

theme.tasklist_plain_task_name = true

theme.notification_bg          = theme.bg
theme.notification_fg          = theme.fg
theme.notification_width       = dpi(225)
theme.notification_max_height  = dpi(80)
theme.notification_icon_size   = dpi(80)

theme.separator_color          = theme.fg2


theme.titlebar_maximized_button_focus_active         = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.warn)
theme.titlebar_maximized_button_focus_inactive       = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.warn)
theme.titlebar_maximized_button_normal_active        = theme_path .. "icons/" .. "circle.svg"
theme.titlebar_maximized_button_normal_inactive      = theme_path .. "icons/" .. "circle.svg"

theme.titlebar_minimize_button_focus                 = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.ok)
theme.titlebar_minimize_button_normal                = theme_path .. "icons/" .. "circle.svg"

theme.titlebar_close_button_normal                   = theme_path .. "icons/" .. "circle.svg"
theme.titlebar_close_button_focus                    = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.err)

theme.layout_floating                                = gears.color.recolor_image(
  theme_path .. "icons/" .. "floating.png", theme.fg1)
theme.layout_tile                                    = gears.color.recolor_image(theme_path .. "icons/" .. "tile.png",
  theme.fg1)

theme.awesomewm                                      = gears.color.recolor_image(
  theme_path .. "icons/" .. "awesomewm.svg", theme.pri)

theme.play                                           = gears.color.recolor_image(theme_path .. "icons/" .. "play.svg",
  theme.fg1)
theme.pause                                          = gears.color.recolor_image(theme_path .. "icons/" .. "pause.svg",
  theme.fg1)

theme.task_preview_widget_border_width               = 0 -- The border width of the widget

theme.systray_icon_spacing                           = dpi(8)

theme.parent_filter_list                             = { "discord", "firefox", "nemo" }
theme.child_filter_list                              = { "discord", "firefox", "nemo" }
theme.swallowing_filter                              = true
theme.playerctl_ignore                               = "firefox"

theme.hotkeys_bg                                     = theme.bg
theme.hotkeys_fg                                     = theme.fg
theme.hotkeys_font                                   = theme.barfont
theme.hotkeys_description_font                       = theme.font .. " 12"
theme.hotkeys_modifiers_fg                           = theme.fg2
theme.hotkeys_label_bg                               = theme.pri
theme.hotkeys_border_width                           = dpi(2)
theme.hotkeys_border_color                           = theme.pri
theme.hotkeys_group_margin                           = 20

theme.profilepicture                                 = theme_path .. "/pics/pfp.jpg"
theme.songdefpicture                                 = theme_path .. "/pics/nosong.jpg"

theme.progressbar_bg                                 = theme.pri .. '11'
theme.progressbar_fg                                 = theme.pri

theme.window_switcher_widget_bg                      = theme.bg2 .. 'cc' -- The bg color of the widget
theme.window_switcher_widget_border_width            = 1 -- The border width of the widget
theme.window_switcher_widget_border_radius           = 5 -- The border radius of the widget
theme.window_switcher_widget_border_color            = theme.pri -- The border color of the widget
theme.window_switcher_clients_spacing                = 25 -- The space between each client item
theme.window_switcher_client_icon_horizontal_spacing = 10 -- The space between client icon and text
theme.window_switcher_client_width                   = 150 -- The width of one client widget
theme.window_switcher_client_height                  = 250 -- The height of one client widget
theme.window_switcher_client_margins                 = 10 -- The margin between the content and the border of the widget
theme.window_switcher_thumbnail_margins              = 10 -- The margin between one client thumbnail and the rest of the widget
theme.thumbnail_scale                                = false -- If set to true, the thumbnails fit policy will be set to "fit" instead of "auto"
theme.window_switcher_name_margins                   = 10 -- The margin of one clients title to the rest of the widget
theme.window_switcher_name_valign                    = "center" -- How to vertically align one clients title
theme.window_switcher_name_forced_width              = 400 -- The width of one title
theme.window_switcher_name_font                      = theme.font .. ' 12' -- The font of all titles
theme.window_switcher_name_normal_color              = theme.fg -- The color of one title if the client is unfocused
theme.window_switcher_name_focus_color               = theme.pri -- The color of one title if the client is focused
theme.window_switcher_icon_valign                    = "center" -- How to vertically align the one icon
theme.window_switcher_icon_width                     = 20 --
-- ICONS
theme.icon_theme                                     = "Reversal"
local icon_dir                                       = os.getenv("HOME") ..
    "/.icons/" .. theme.icon_theme .. "/apps/scalable/"
theme.ic_icons                                       = {
  ["st"] = icon_dir .. "terminal.svg",
  ["st-256color"] = icon_dir .. "terminal.svg",
  ["pfetchpad"] = icon_dir .. "terminal.svg",
  ["discord"] = icon_dir .. "discord.svg",
  ["firefox"] = icon_dir .. "firefox.svg",
  ["feh"] = icon_dir .. "image-viewer.svg",
  ["Spotify"] = icon_dir .. "spotify.svg",
  ["ncmpcpppad"] = icon_dir .. "deepin-music-player.svg",
  ["SimpleScreenRecorder"] = icon_dir .. "screenrecorder.svg",
}
theme.ic_dynamic_classes                             = { "st-256color" }
return theme
