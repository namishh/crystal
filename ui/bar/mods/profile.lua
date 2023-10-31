local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local profile = wibox.widget {
  widget = wibox.widget.imagebox,
  image = beautiful.pfp,
  forced_height = 40,
  forced_width = 40,
  clip_shape = helpers.rrect(40),
  resize = true,
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::launcher')
    end)
  },
}

return profile
