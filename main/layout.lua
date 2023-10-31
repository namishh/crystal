local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"

awful.layout.layouts = {
  awful.layout.suit.tile,
  awful.layout.suit.floating,
}

client.connect_signal("mouse::enter", function(c)
  c:activate { context = "mouse_enter", raise = false }
end)

client.connect_signal("manage", function(c)
  if awesome.startup then awful.client.setslave(c) end
end)
