local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local battery = wibox.widget {
  {
    max_value        = 100,
    value            = 69,
    id               = "prog",
    forced_height    = 22,
    forced_width     = 45,
    paddings         = 3,
    border_color     = beautiful.fg .. "99",
    background_color = beautiful.mbg,
    bar_shape        = helpers.rrect(3),
    color            = beautiful.blue,
    border_width     = 1.25,
    shape            = helpers.rrect(5),
    widget           = wibox.widget.progressbar
  },
  {
    {
      bg = beautiful.fg .. "99",
      forced_height = 10,
      forced_width = 2,
      shape = helpers.rrect(10),
      widget = wibox.container.background,
    },
    widget = wibox.container.place,
    valign = "center",
  },
  spacing = 3,
  layout = wibox.layout.fixed.horizontal
}
awesome.connect_signal("signal::battery", function(value)
  local b = battery:get_children_by_id("prog")[1]
  b.value = value
  if value > 80 then
    b.color = beautiful.green
  elseif value > 20 then
    b.color = beautiful.blue
  else
    b.color = beautiful.red
  end
end)

return battery
