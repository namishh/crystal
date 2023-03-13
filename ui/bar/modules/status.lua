-- Status
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")

local wifi      = wibox.widget {
  font = beautiful.icofont .. " 12",
  markup = "󰤨",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}
local battery   = wibox.widget {
  widget = wibox.container.arcchart,
  max_value = 100,
  min_value = 0,
  value = 69,
  thickness = dpi(3),
  rounded_edge = true,
  bg = beautiful.ok .. "4D",
  colors = { beautiful.ok },
  start_angle = math.pi + math.pi / 2,
  forced_width = dpi(15),
  forced_height = dpi(15)
}
local l         = nil
if beautiful.barDir == 'left' or beautiful.barDir == 'right' then
  l = wibox.layout.fixed.vertical
  wifi.font = beautiful.icofont .. " 12"
  battery.forced_width = dpi(15)
  battery.forced_height = dpi(15)
else
  l = wibox.layout.fixed.horizontal
  wifi.font = beautiful.icofont .. " 14"
  battery.forced_width = dpi(17)
  battery.forced_height = dpi(17)
end
local status = wibox.widget {
  {
    {
      {
        battery,
        wifi,
        layout = l,
        spacing = dpi(15)
      },
      margins = { top = dpi(10), bottom = dpi(10), left = dpi(6), right = dpi(6) },
      widget = wibox.container.margin
    },
    layout = wibox.layout.stack
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::dashboard')
    end)
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
  bg = beautiful.bg2 .. "cc"
}

awesome.connect_signal("signal::network", function(value)
  if value then
    wifi.markup = helpers.colorizeText("󰤨", beautiful.fg)
  else
    wifi.markup = helpers.colorizeText("󰤮", beautiful.fg .. "99")
  end
end)



awesome.connect_signal("signal::battery", function(value)
  battery.value = value
end)

return status
