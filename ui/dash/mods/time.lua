local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget {
  {
    {
      {
        {
          font = beautiful.sans .. " SemiBold 42",
          format = helpers.colorizeText("%I : %M", beautiful.fg),
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        {
          font = beautiful.sans .. " 16",
          format = helpers.colorizeText("%A, %d %B", beautiful.fg2 .. '99'),
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        spacing = 8,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center"
    },
    widget = wibox.container.margin,
    margin = 30,
  },
  shape = helpers.rrect(20),
  forced_height = 200,
  widget = wibox.container.background,
  bg = beautiful.mbg
}

return widget
