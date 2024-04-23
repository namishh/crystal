local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")

local bluetooth = wibox.widget {
  {
    widget = wibox.widget.imagebox,
    image = beautiful.network_connected,
    forced_height = 22,
    id = "image",
    forced_width = 22,
    resize = true,
  },
  widget = wibox.container.place,
  valign = "center",
}
awesome.connect_signal("signal::bluetooth", function(value)
  if value then
    helpers.gc(bluetooth, 'image').image = beautiful.bluetooth_connected
  else
    helpers.gc(bluetooth, 'image').image = beautiful.bluetooth_disconnected
  end
end)

return bluetooth
