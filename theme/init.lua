local theme              = {}
local xresources         = require("beautiful.xresources")
local colors             = require("theme.colors")
local dpi                = xresources.apply_dpi
local gfs                = require("gears.filesystem")
local gears              = require("gears")
local appearConfig       = require("config.appearance")
local theme_path         = gfs.get_configuration_dir() .. "/theme/"
theme.barfont            = 'Iosevka Nerd Font 13'
theme.font               = 'Iosevka Nerd Font'
theme.sans               = "Dosis"
theme.icofont            = 'Material Design Icons'

theme.titlebarType       = appearConfig.titlebarType
theme.barDir             = appearConfig.barDir
theme.barPadding         = appearConfig.gaps
theme.barSize            = appearConfig.barSize
theme.dockSize           = appearConfig.dockSize
theme.barShouldHaveGaps  = appearConfig.barShouldHaveGaps

theme.scrheight          = appearConfig.scrheight
theme.scrwidth           = appearConfig.scrwidth

theme.wall               = colors.wall

theme.name               = colors.name
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
theme.fg_normal          = theme.fg
theme.fg_minimize        = theme.fg2

theme.bg_normal          = theme.bg2
theme.bg_urgent          = theme.err .. "40"
theme.bg_minimize        = theme.fg .. "10"
theme.bg_focus           = theme.fg2 .. "cc"

theme.useless_gap        = math.ceil(appearConfig.gaps / 4)
theme.snap_bg            = theme.fg2

theme.border_width       = dpi(5)
theme.border_color       = theme.bg2

theme.titlebar_fg        = theme.fg
theme.titlebar_fg_normal = theme.fg2
theme.titlebar_fg_focus  = theme.fg
theme.titlebar_bg        = theme.bg2
theme.titlebar_bg_normal = theme.bg
theme.titlebar_font      = theme.font


theme.taglist_bg               = theme.bg .. "00"
theme.taglist_bg_focus         = theme.pri
theme.taglist_fg_focus         = theme.fg
theme.taglist_bg_urgent        = theme.err
theme.taglist_fg_urgent        = theme.fg
theme.taglist_bg_occupied      = theme.fg .. 'cc'
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
theme.menu_width               = dpi(200)
theme.menu_border_width        = dpi(10)

theme.tasklist_plain_task_name = true

theme.notification_bg          = theme.bg
theme.notification_fg          = theme.fg
theme.notification_width       = dpi(225)
theme.notification_max_height  = dpi(80)
theme.notification_icon_size   = dpi(80)

theme.separator_color          = theme.fg2


theme.profilepicture = theme_path .. "/pics/pfps/cool.jpg"
theme.songdefpicture = theme_path .. "/pics/nosong.jpg"
theme.menupicture = theme_path .. "/pics/menu2.png"
theme.nixlogo = theme_path .. "/pics/nix.png"


theme.titlebar_maximized_button_focus_active    = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.warn)
theme.nonotif                                   = theme_path .. "icons/" .. "bells.png"
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.warn)
theme.titlebar_maximized_button_normal_active   = theme_path .. "icons/" .. "circle.svg"
theme.titlebar_maximized_button_normal_inactive = theme_path .. "icons/" .. "circle.svg"

theme.titlebar_minimize_button_focus            = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.ok)
theme.titlebar_minimize_button_normal           = theme_path .. "icons/" .. "circle.svg"

theme.titlebar_close_button_normal              = theme_path .. "icons/" .. "circle.svg"
theme.titlebar_close_button_focus               = gears.color.recolor_image(theme_path .. "icons/" .. "circle.svg",
  theme.err)

theme.layout_floating                           = gears.color.recolor_image(
  theme_path .. "icons/" .. "floating.png", theme.fg1)
theme.layout_tile                               = gears.color.recolor_image(theme_path .. "icons/" .. "tile.png",
  theme.fg1)

theme.awesomewm                                 = gears.color.recolor_image(
  theme_path .. "icons/" .. "awesomewm.svg", theme.pri)

theme.play                                      = gears.color.recolor_image(theme_path .. "icons/" .. "play.svg",
  theme.fg1)
theme.pause                                     = gears.color.recolor_image(theme_path .. "icons/" .. "pause.svg",
  theme.fg1)

theme.task_preview_widget_border_width          = 0 -- The border width of the widget

theme.systray_icon_spacing                      = dpi(8)

theme.hotkeys_bg                                = theme.bg
theme.hotkeys_fg                                = theme.fg
theme.hotkeys_font                              = theme.barfont
theme.hotkeys_description_font                  = theme.font .. " 12"
theme.hotkeys_modifiers_fg                      = theme.fg2
theme.hotkeys_label_bg                          = theme.pri
theme.hotkeys_border_width                      = dpi(2)
theme.hotkeys_border_color                      = theme.pri
theme.hotkeys_group_margin                      = 20

theme.playerctl_ignore                          = { "firefox", "spotify" }
theme.playerctl_player                          = { "mpd", "%any" }
theme.playerctl_update_on_activity              = false
theme.playerctl_position_update_interval        = 1
theme.playerctl_backend                         = "playerctl_lib"

theme.icon_dir                                  = colors.iconTheme .. "/apps/scalable/"
theme.progressbar_bg                            = theme.pri .. '11'
theme.progressbar_fg                            = theme.pri
return theme
