local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local widget = wibox.widget {
  {
    {
      {
        widget = wibox.widget.textbox,
        font = beautiful.sans .. " Bold 14",
        markup = "Control Panel"
      },
      {
        {
          widget = wibox.widget.textbox,
          font = beautiful.sans .. " 12",
          valign = "center",
          markup = helpers.colorizeText("Hello " .. beautiful.user .. "!", beautiful.comm)
        },
        {
          widget = wibox.widget.textbox,
          font = beautiful.sans .. " 15",
          valign = "center",
          markup = helpers.colorizeText(" ⋅ ", beautiful.comm)
        },
        {
          font = beautiful.sans .. " 12",
          format = helpers.colorizeText("%A, %d %B", beautiful.comm),
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        spacing = 3,
        layout = wibox.layout.fixed.horizontal,
      },
      spacing = 3,
      layout = wibox.layout.fixed.vertical,
    },
    nil,
    {
      {
        {
          clip_shape = helpers.rrect(100),
          widget = wibox.widget.imagebox,
          image = beautiful.pfp,
          opacity = 0.85,
          forced_height = 45,
          forced_width = 45,
        },
        widget = wibox.container.background,
        bg = beautiful.mbg,
        shape_border_width = 4,
        shape = helpers.rrect(100),
        shape_border_color = beautiful.fg3,
      },
      widget = wibox.container.place,
      valign = "center"
    },
    layout = wibox.layout.align.horizontal,
  },
  widget = wibox.container.margin,
  margins = 15,
}

return widget
