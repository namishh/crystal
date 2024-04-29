-- Theme handling library
local beautiful     = require('beautiful')
-- Standard awesome library
local gears         = require('gears')

-- Themes define colors, icons, font and wallpapers.
local xresources    = require "beautiful.xresources"
local rnotification = require "ruled.notification"
local dpi           = xresources.apply_dpi
local gears         = require "gears"
local gfs           = require "gears.filesystem"
local helpers       = require "helpers"
local themes_path   = gfs.get_configuration_dir() .. "theme/"
local theme         = {}


local home      = os.getenv 'HOME'

----- User Preferences -----

theme.user      = string.gsub(os.getenv('USER'), '^%l', string.upper)
theme.hostname  = os.getenv('HOST')
----- Font -----
local themeName = "dawn"
local colors    = require("theme.colors." .. themeName)


theme.wallpaper      = themes_path .. "walls/" .. require("config.user").wallpaper
theme.pfp            = themes_path .. "pics/pfp.png"
theme.pfpname        = themes_path .. "pics/pfpname.png"
theme.scheme         = themeName
theme.sans           = "Lexend"
theme.mono           = "Fantasque Sans M Nerd Font"
theme.icon           = "Material Design Icons"
theme.font           = "Lexend 12"
theme.prompt_font    = theme.font
----- General/default Settings -----

theme.bg_normal      = colors.bg
theme.bg_focus       = colors.bg
theme.bg_urgent      = colors.bg
theme.bg_minimize    = colors.bg
theme.bg_systray     = colors.mbg

theme.style          = colors.type

theme.fg_normal      = colors.fg
theme.fg_focus       = theme.fg_normal
theme.fg_urgent      = theme.fg_normal
theme.fg_minimize    = theme.fg_normal

theme.useless_gap    = dpi(6)
theme.border_width   = dpi(0)

-- Colors

theme.blue           = colors.pri
theme.yellow         = colors.warn
theme.green          = colors.ok
theme.red            = colors.err
theme.magenta        = colors.dis
theme.transparent    = "#00000000"

theme.fg             = colors.fg

theme.bg             = colors.bg
--theme.dbg            = colors.dbg
theme.bg_alt         = colors.mbg
theme.mab            = "#edebe8"
theme.mbg            = colors.mbg
theme.bg3            = colors.bg3
theme.bg4            = colors.bg4

theme.fg             = colors.fg
theme.fg1            = colors.fg2
theme.fg2            = colors.fg3
theme.fg3            = colors.fg4

theme.comm           = colors.comm

-- Menu

theme.menu_height    = dpi(30)
theme.menu_width     = dpi(200)
theme.menu_bg_focus  = theme.bg
theme.menu_bg_normal = theme.bg
theme.submenu        = ">"


theme.taglist_bg               = theme.bg .. "00"
theme.taglist_bg_focus         = theme.bg
theme.taglist_fg_focus         = theme.blue
theme.taglist_bg_urgent        = theme.red
theme.taglist_fg_urgent        = theme.fg
theme.taglist_bg_occupied      = colors.bg
theme.taglist_fg_occupied      = theme.fg
theme.taglist_bg_empty         = colors.bg
theme.taglist_fg_empty         = colors.comm
theme.taglist_disable_icon     = true

theme.tasklist_fg_normal       = theme.fg3
theme.tasklist_fg_focus        = theme.fg
theme.tasklist_fg_minimize     = theme.fg

theme.tasklist_bg_normal       = theme.bg
theme.tasklist_bg_focus        = theme.blue .. '18'
theme.tasklist_bg_minimize     = theme.bg4
theme.tasklist_plain_task_name = true

theme.notification_spacing     = 15


theme.layout_floating = gears.color.recolor_image(themes_path .. "icons/layout/floating.png",
  theme.red)
theme.layout_tile     = gears.color.recolor_image(themes_path .. "icons/layout/tile.png",
  theme.red)

theme.songdefpicture  = themes_path .. "pics/default_song.png"


theme.arch                 = themes_path .. "pics/arch.png"

theme.network_connected    = gears.color.recolor_image(themes_path .. "icons/network-connected.svg",
  theme.fg)
theme.network_disconnected = gears.color.recolor_image(themes_path .. "icons/network-disconnected.svg",
  theme.fg)


theme.bluetooth_connected    = gears.color.recolor_image(
  themes_path .. "icons/bluetooth-connected.svg",
  theme.fg)
theme.bluetooth_disconnected = gears.color.recolor_image(
  themes_path .. "icons/bluetooth-disconnected.svg",
  theme.fg)

theme.awesome_icon           = gears.color.recolor_image(themes_path .. "icons/awesome.svg",
  theme.magenta .. '99')

theme.trash                  = gears.color.recolor_image(themes_path .. "icons/trash.svg",
  theme.red)


theme.tag_fill                                  = gears.color.recolor_image(themes_path .. "icons/tags/heart-fill.svg",
  theme.red)
theme.tag_occ                                   = gears.color.recolor_image(themes_path .. "icons/tags/heart-fill.svg",
  theme.blue)
theme.tag_emp                                   = gears.color.recolor_image(themes_path .. "icons/tags/heart.svg",
  theme.comm)

theme.check                                     = gears.color.recolor_image(themes_path .. "icons/check.svg",
  theme.fg)

theme.notif_bell                                = gears.color.recolor_image(themes_path .. "icons/bell.png",
  theme.blue)

theme.titlebar_left                             = gears.color.recolor_image(
  themes_path .. "icons/titlebars/titlebar.svg",
  theme.fg)

theme.titlebar_close_button_normal              = gears.color.recolor_image(themes_path .. "icons/titlebars/close.svg",
  theme.fg3)
theme.titlebar_close_button_focus               = gears.color.recolor_image(themes_path .. "icons/titlebars/close.svg",
  theme.red)

theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(
  themes_path .. "icons/titlebars/maximize.svg",
  theme.fg3)
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(
  themes_path .. "icons/titlebars/maximize.svg",
  theme.blue)
theme.titlebar_maximized_button_normal_active   = gears.color.recolor_image(
  themes_path .. "icons/titlebars/maximize.svg",
  theme.fg3)
theme.titlebar_maximized_button_focus_active    = gears.color.recolor_image(
  themes_path .. "icons/titlebars/maximize.svg",
  theme.blue)

theme.titlebar_minimize_button_normal           = gears.color.recolor_image(
  themes_path .. "icons/titlebars/minimize.svg", theme.fg3)
theme.titlebar_minimize_button_focus            = gears.color.recolor_image(
  themes_path .. "icons/titlebars/minimize.svg", theme.magenta)

theme.icon_theme                                = "Papirus"

rnotification.connect_signal('request::rules', function()
  rnotification.append_rule {
    rule       = { urgency = 'critical' },
    properties = { bg = '#ff0000', fg = '#ffffff' }
  }
end)

return theme
