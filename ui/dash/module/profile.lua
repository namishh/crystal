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
          {
            widget = wibox.widget.imagebox,
            image = beautiful.pfpname,
            forced_height = 100,
            forced_width = 100,
            clip_shape = helpers.rrect(100),
            resize = true,
          },
          widget = wibox.container.place,
          valign = 'center',
          halign = 'center',
        },
        widget = wibox.container.background,
        shape_border_width = 0,
        shape = helpers.rrect(100),
        shape_border_color = beautiful.fg3,
      },
      {
        markup = helpers.colorizeText('Hello Nam!', beautiful.fg),
        forced_height = 15,
        font = "Lexend 14",
        halign = 'center',
        widget = wibox.widget.textbox,
      },
      {
        markup = helpers.colorizeText('', beautiful.comm),
        forced_height = 15,
        font = "Lexend 12",
        id = "uptime",
        halign = 'center',
        widget = wibox.widget.textbox,
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.place,
    valign = 'center',
    halign = 'center',
  },
  widget = wibox.container.background,
  bg = beautiful.bg,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
  forced_height = 250,
}

awesome.connect_signal("signal::uptime", function(v)
  helpers.gc(widget, "uptime").markup = helpers.colorizeText("Up for " .. v, beautiful.comm)
end)

return widget
