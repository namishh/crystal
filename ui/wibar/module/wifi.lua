local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")

local wifi      = wibox.widget {
  {
    widget = wibox.widget.imagebox,
    image = beautiful.network_connected,
    forced_height = 25,
    id = "image",
    forced_width = 25,
    resize = true,
  },
  widget = wibox.container.place,
  valign = "center",
}
awesome.connect_signal("signal::network", function(value)
  if value then
    helpers.gc(wifi, 'image').image = beautiful.network_connected
  else
    helpers.gc(wifi, 'image').image = beautiful.network_disconnected
  end
end)

return wifi
