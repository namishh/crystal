local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local vars = require 'config.vars'

local dock_programs = {
  { "nemo",                                                         "nemo",                "Files" },
  { "firefox",                                                      "firefox",             "Firefox" },
  { "st -e sh -c 'nvim; $SHELL'",                                   "neovim",              "Neovim" },
  { "st",                                                           "terminal",            "Simple Terminal" },
  { "awesome-client 'awesome.emit_signal(\"toggle::ncmpcpppad\")'", "deepin-music-player", "ncmpcpp" },
  { "awesome-client 'awesome.emit_signal(\"toggle::control\")'",    "settings",            "Settings" },
}

screen.connect_signal('request::wallpaper', function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      {
        image     = beautiful.wall,
        upscale   = false,
        downscale = false,
        widget    = wibox.widget.imagebox,
      },
      valign = 'center',
      halign = 'center',
      tiled = false,
      widget = wibox.container.tile,
    }

  }
end)

screen.connect_signal('request::desktop_decoration', function(s)
  awful.tag(vars.tags, s, awful.layout.layouts[1])
  require("ui.dock")(s)
end)
