local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")

local createProgress = function(col, label, signal)
  local widget = wibox.widget {
    {
      {
        {
          font = beautiful.sans .. " Light 11",
          markup = helpers.colorizeText(label, beautiful.fg),
          widget = wibox.widget.textbox,
          valign = "start",
          align = "center"
        },
        widget = wibox.container.background,
        forced_width = 50,
      },
      widget = wibox.container.margin,
      right = 30,
    },
    {
      id               = "pro",
      max_value        = 100,
      value            = 0,
      forced_height    = 20,
      forced_width     = 300,
      bar_shape        = helpers.rrect(5),
      shape            = helpers.rrect(5),
      color            = col,
      background_color = col .. '11',
      paddings         = 1,
      border_width     = 1,
      widget           = wibox.widget.progressbar,
    },
    nil,
    layout = wibox.layout.align.horizontal,
  }

  awesome.connect_signal('signal::' .. signal, function(val)
    helpers.gc(widget, "pro").value = val
  end)

  return widget
end

local widget = {
  {
    {
      createProgress(beautiful.red, "CPU", "cpu"),
      createProgress(beautiful.blue, "MEM", "memory"),
      createProgress(beautiful.magenta, "DIS", "disk"),
      spacing = 30,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 30
  },
  widget = wibox.container.background,
  bg = beautiful.mbg
}

return widget
