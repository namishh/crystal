local xresources    = require "beautiful.xresources"
local rnotification = require "ruled.notification"
local dpi           = xresources.apply_dpi
local gears         = require "gears"
local gfs           = require "gears.filesystem"
local helpers       = require "helpers"
local settings      = require "setup".settings
-- Var
local themes_path   = gfs.get_configuration_dir() .. "theme/"
local walls_path    = "~/.local/pictures/Walls/"
local home          = os.getenv 'HOME'

local theme         = {}

local data          = helpers.readJson(gears.filesystem.get_cache_dir() .. "json/settings.json")



----- User Preferences -----


theme.pfp       = data.pfp
theme.user      = string.gsub(os.getenv('USER'), '^%l', string.upper)
theme.hostname  = os.getenv('HOST')
----- Font -----
local themeName = settings.colorscheme
local colors    = require("theme.colors." .. themeName)


theme.wallpaper      = themes_path .. "walls/" .. colors.name .. ".jpg"
theme.iconThemePath  = settings.iconTheme
theme.scheme         = themeName
theme.sans           = "Rubik"
theme.mono           = "Iosevka Nerd Font"
theme.icon           = "Material Design Icons"
theme.font           = "Rubik 12"
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

theme.useless_gap    = dpi(tonumber(data.gaps))
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
theme.bg_alt         = colors.mbg

theme.mbg            = colors.mbg
theme.bg3            = colors.bg3
theme.bg4            = colors.bg4

theme.fg             = colors.fg
theme.fg1            = colors.fg2
theme.fg2            = colors.fg3
theme.fg3            = colors.fg4

-- Menu

theme.menu_height    = dpi(40)
theme.menu_width     = dpi(200)
theme.menu_bg_focus  = theme.bg
theme.menu_bg_normal = theme.bg
theme.submenu        = ">"


theme.taglist_bg           = theme.bg .. "00"
theme.taglist_bg_focus     = theme.blue
theme.taglist_fg_focus     = theme.fg
theme.taglist_bg_urgent    = theme.red
theme.taglist_fg_urgent    = theme.fg
theme.taglist_bg_occupied  = colors.fg3 .. '33'
theme.taglist_fg_occupied  = theme.fg
theme.taglist_bg_empty     = colors.fg3 .. '33'
theme.taglist_fg_empty     = colors.fg
theme.taglist_disable_icon = true


theme.tasklist_bg_normal                        = theme.bg
theme.tasklist_bg_focus                         = theme.bg2
theme.tasklist_bg_minimize                      = theme.bg3

-- titlebar's buttons
theme.titlebar_close_button_normal              = gears.color.recolor_image(themes_path .. "assets/titlebar/close_1.png",
  theme.bg3)
theme.titlebar_close_button_focus               = gears.color.recolor_image(themes_path .. "assets/titlebar/close_2.png",
  theme.red)

theme.layout_floating                           = gears.color.recolor_image(themes_path .. "assets/floating.png",
  theme.fg)
theme.layout_tile                               = gears.color.recolor_image(themes_path .. "assets/tile.png",
  theme.fg)

theme.nixos                                     = themes_path .. "assets/nixos.png",
    theme.fg
theme.titlebar_minimize_button_normal           = gears.color.recolor_image(
  themes_path .. "assets/titlebar/minimize_1.png", theme.bg3)
theme.titlebar_minimize_button_focus            = gears.color.recolor_image(
  themes_path .. "assets/titlebar/minimize_2.png", theme.green)

theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(themes_path .. "assets/titlebar/close_1.png",
  theme.bg3)
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(themes_path .. "assets/titlebar/close_1.png",
  theme.yellow)
theme.titlebar_maximized_button_normal_active   = gears.color.recolor_image(themes_path .. "assets/titlebar/close_1.png",
  theme.bg3)
theme.titlebar_maximized_button_focus_active    = gears.color.recolor_image(themes_path .. "assets/titlebar/close_1.png",
  theme.yellow)

theme.icon_theme                                = "Reversal"


theme.songdefpicture = themes_path .. "/assets/defsong.jpg"

rnotification.connect_signal('request::rules', function()
  rnotification.append_rule {
    rule       = { urgency = 'critical' },
    properties = { bg = '#ff0000', fg = '#ffffff' }
  }
end)

return theme
