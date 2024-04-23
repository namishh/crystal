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
          font = beautiful.sans .. " 14",
          markup = helpers.colorizeText("All our dreams can come true if we have the courage to pursue them", beautiful.fg),
          widget = wibox.widget.textbox,
          valign = "start",
          align = "center"
        },
        {

          font = beautiful.sans .. " Bold 12",
          markup = helpers.colorizeText("Walt Disney", beautiful.comm),
          widget = wibox.widget.textbox,
          valign = "start",
          align = "center"
        },
        spacing = 10,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 29
    },
    widget = wibox.container.place,
    valign = 'center',
  },
  widget = wibox.container.background,
  bg = beautiful.bg,
  forced_width = 460,
  shape = helpers.rrect(5),
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
}

return widget
