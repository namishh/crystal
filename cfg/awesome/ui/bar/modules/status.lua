-- Status
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")

local wifi = wibox.widget {
  font = beautiful.icofont .. " 14",
  markup = "󰤨",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}
local battery = wibox.widget {
  widget = wibox.container.arcchart,
  max_value = 100,
  min_value = 0,
  value = 69,
  thickness = dpi(3),
  rounded_edge = true,
  bg = beautiful.ok .. "4D",
  colors = { beautiful.ok },
  start_angle = math.pi + math.pi / 2,
  forced_width = dpi(17),
  forced_height = dpi(17)
}

local status = wibox.widget {
  {
    {
      {
        battery,
        wifi,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(15)
      },
      margins = { left = dpi(12), right = dpi(12) },
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
  bg = beautiful.bg3 .. "cc"
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
