local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local createProgress = function(signal, name)
  local progress = wibox.widget {
    max_value        = 100,
    value            = 50,
    forced_height    = 80,
    forced_width     = 200,
    shape            = helpers.rrect(0),
    bar_shape        = helpers.rrect(0),
    color            = beautiful.fg,
    background_color = beautiful.bg .. '00',
    paddings         = 1,
    widget           = wibox.widget.progressbar,
  }
  awesome.connect_signal('signal::' .. signal, function(value)
    progress.value = value
  end)
  return wibox.widget {
    {
      progress,
      forced_height = 400,
      forced_width  = 60,
      direction     = 'east',
      layout        = wibox.container.rotate,
    },
    {
      markup = helpers.colorizeText(name, beautiful.comm),
      forced_height = 15,
      font = "Lexend 12",
      halign = 'center',
      widget = wibox.widget.textbox,
    },
    spacing = 10,
    layout = wibox.layout.fixed.vertical,
  }
end

local widget = wibox.widget {
  {
    {
      {
        markup = helpers.colorizeText("Statistics", beautiful.fg),
        font = "Lexend 16",
        widget = wibox.widget.textbox,
      },
      {
        {
          {
            {
              {
                markup = helpers.colorizeText('100', beautiful.comm),
                forced_height = 15,
                font = "Lexend 12",
                halign = 'center',
                widget = wibox.widget.textbox,
              },
              {
                markup = helpers.colorizeText('50', beautiful.comm),
                forced_height = 15,
                font = "Lexend 12",
                valign = 'center',
                halign = 'center',
                widget = wibox.widget.textbox,
              },
              {
                markup = helpers.colorizeText('00', beautiful.comm),
                forced_height = 15,
                font = "Lexend 12",
                halign = 'center',
                widget = wibox.widget.textbox,
              },
              layout = wibox.layout.align.vertical,
            },
            forced_height = 400,
            widget = wibox.container.background,
          },
          widget = wibox.container.place,
          valign = "top",
        },
        {
          spacing = 20,
          createProgress("cpu", "SYS"),
          createProgress("battery", "BAT"),
          createProgress("disk", "SSD"),
          createProgress("mem", "RAM"),
          layout = wibox.layout.fixed.horizontal,
        },
        spacing = 20,
        layout = wibox.layout.fixed.horizontal,
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    top = 30,
    left = 30,
    right = 50,
    bottom = 30,
  },
  widget = wibox.container.background,
  bg = beautiful.bg,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
}

return widget
