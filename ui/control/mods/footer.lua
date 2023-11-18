local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local widget = wibox.widget {
  {
    {
      max_value        = 100,
      value            = 69,
      id               = "prog",
      forced_height    = 35,
      forced_width     = 80,
      paddings         = 3,
      border_color     = beautiful.fg .. "99",
      background_color = beautiful.mbg,
      bar_shape        = helpers.rrect(50),
      color            = beautiful.blue,
      border_width     = 0,
      shape            = helpers.rrect(40),
      widget           = wibox.widget.progressbar
    },
    {
      font = beautiful.sans .. " 12",
      markup = helpers.colorizeText("25%", beautiful.fg),
      valign = "center",
      id = "batvalue",
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.horizontal,
    spacing = 10
  },
  nil,
  {
    font = beautiful.sans .. " 14",
    markup = helpers.colorizeText("Hello, " .. beautiful.user .. "!", beautiful.fg),
    valign = "center",
    widget = wibox.widget.textbox,
  },
  layout = wibox.layout.align.horizontal
}
awesome.connect_signal("signal::battery", function(value)
  local b = widget:get_children_by_id("prog")[1]
  local v = widget:get_children_by_id("batvalue")[1]
  v.markup = helpers.colorizeText(value .. "%", beautiful.fg)
  b.value = value
  if value > 80 then
    b.color = beautiful.green
  elseif value > 20 then
    b.color = beautiful.blue
  else
    b.color = beautiful.red
  end
end)

return widget
