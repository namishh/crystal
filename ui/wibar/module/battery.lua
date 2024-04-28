local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local battery = wibox.widget {
  {
    max_value     = 100,
    value         = 69,
    id            = "prog",
    forced_height = 20,
    forced_width  = 20,
    bg            = beautiful.mbg,
    bar_shape     = helpers.rrect(3),
    colors        = { beautiful.blue },
    border_width  = 0,
    thickness     = 3,
    shape         = helpers.rrect(5),
    widget        = wibox.container.arcchart
  },
  widget = wibox.container.place,
  valign = "center",
}
awesome.connect_signal("signal::battery", function(value)
  local b = battery:get_children_by_id("prog")[1]
  b.value = value
end)

return battery
