local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require "beautiful"
local gears     = require("gears")
local helpers   = require "helpers"

local widget    = wibox.widget {
  {
    {
      {
        {
          id            = "icon",
          image         = gears.filesystem.get_configuration_dir() .. "theme/assets/weather/icons/weather-fog.svg",
          opacity       = 0.9,
          clip_shape    = helpers.rrect(4),
          forced_height = 100,
          forced_width  = 100,
          valign        = "center",
          widget        = wibox.widget.imagebox
        },
        {
          {
            id = "temp",
            font = beautiful.sans .. " 36",
            markup = "31 C",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          {
            id = "desc",
            font = beautiful.sans .. " 14",
            markup = "Scattered Clouds",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          spacing = 8,
          layout = wibox.layout.fixed.vertical,
        },
        spacing = 120,
        layout = wibox.layout.fixed.horizontal,
      },
      widget = wibox.container.place,
      valign = "center",
    },
    widget = wibox.container.margin,
    margins = 25,
  },
  widget = wibox.container.background,
  bg = beautiful.mbg,
  shape = helpers.rrect(20),
  forced_height = 195,
}

awesome.connect_signal("signal::weather", function(out)
  helpers.gc(widget, "icon").image = out.image
  helpers.gc(widget, "temp").markup = out.temp .. "°C"
  helpers.gc(widget, "desc").markup = out.desc
end)
return widget
