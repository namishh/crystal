local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")
local beautiful = require("beautiful")
local gears     = require("gears")

local widget    = wibox.widget {
  {
    id            = "image",
    image         = gears.filesystem.get_configuration_dir() .. "theme/assets/weather/icons/weather-fog.svg",
    opacity       = 0.9,
    clip_shape    = helpers.rrect(4),
    forced_height = 30,
    forced_width  = 30,
    valign        = "center",
    widget        = wibox.widget.imagebox
  },
  {
    id = "desc",
    font = beautiful.sans .. " 16",
    markup = "Scattered Clouds",
    valign = "center",
    align = "start",
    widget = wibox.widget.textbox,
  },
  layout = wibox.layout.fixed.horizontal,
  spacing = 15,
}

awesome.connect_signal("signal::weather", function(out)
  helpers.gc(widget, "desc").markup = out.desc
  helpers.gc(widget, "image").image = out.image
end)

return widget
