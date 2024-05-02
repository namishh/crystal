local playerctl = require("mods.playerctl").lib()
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")


local createProgress = function(signal, color)
  local progress = wibox.widget {
    max_value        = 100,
    value            = 50,
    forced_height    = 80,
    forced_width     = 200,
    shape            = helpers.rrect(40),
    bar_shape        = helpers.rrect(40),
    color            = color,
    background_color = beautiful.bg .. '00',
    paddings         = 1,
    widget           = wibox.widget.progressbar,
  }
  awesome.connect_signal('signal::' .. signal, function(value)
    progress.value = value
  end)
  return wibox.widget {
    progress,
    forced_height = 200,
    forced_width  = 20,
    direction     = 'east',
    layout        = wibox.container.rotate,
  }
end


local widget = wibox.widget {
  {
    {
      {
        createProgress("cpu", beautiful.blue),
        createProgress("battery", beautiful.red),
        createProgress("disk", beautiful.green),
        createProgress("mem", beautiful.magenta),

        layout = wibox.layout.fixed.horizontal,
        spacing = 15,
      },
      widget = wibox.container.place,
      halign = "center",
    },
    margins = 30,
    widget = wibox.container.margin,
  },
  widget        = wibox.container.background,
  shape         = helpers.rrect(15),
  bg            = beautiful.bg,
  forced_height = 265,
  forced_width  = 265,
}

return widget
