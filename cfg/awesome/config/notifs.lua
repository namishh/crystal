local naughty                   = require 'naughty'
local awful                     = require 'awful'
local gears                     = require 'gears'
local beautiful                 = require 'beautiful'
local xresources                = require("beautiful.xresources")
local dpi                       = xresources.apply_dpi
naughty.config.defaults.ontop   = true
naughty.config.defaults.timeout = 3
naughty.config.defaults.screen  = awful.screen.focused()

naughty.config.padding = dpi(10)
local rrect = function(rad)
  return function(cr, width, height)
    gears.shape.rounded_rect(cr, width, height, rad)
  end
end
naughty.config.spacing = dpi(5)
naughty.config.defaults.shape = rrect(beautiful.br)

naughty.config.defaults.border_width = dpi(15)
naughty.config.defaults.border_color = beautiful.bg

naughty.config.defaults.title = "Notification"
naughty.config.defaults.position = "top_left"

naughty.config.defaults.fg = beautiful.fg
naughty.config.defaults.bg = beautiful.bg

naughty.config.presets.normal = {
  fg = beautiful.fg,
  bg = beautiful.bg,
}

naughty.config.presets.low = {
  fg = beautiful.ok,
  bg = beautiful.bg,
}

naughty.config.presets.critical = {
  fg = beautiful.err,
  bg = beautiful.bg,
}
