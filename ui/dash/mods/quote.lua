local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")

local widget = wibox.widget {
  {
    {
      {
        {
          font = beautiful.sans .. " 16",
          markup = helpers.colorizeText("All our dreams can come true if we have the courage to pursue them", beautiful.fg),
          widget = wibox.widget.textbox,
          valign = "start",
          align = "center"
        },
        {

          font = beautiful.sans .. " Bold 12",
          markup = helpers.colorizeText("Walt Disney", beautiful.magenta),
          widget = wibox.widget.textbox,
          valign = "start",
          align = "center"
        },
        spacing = 20,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 30
    },
    widget = wibox.container.background,
    bg = beautiful.mbg,
    shape = helpers.rrect(20),
  },
  widget = wibox.container.margin,
  top = 20
}

return widget
