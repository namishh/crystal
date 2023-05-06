local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

local elems = require("ui.popups.winswitch.elements")

local winswitch = function(s)
  local winlist = wibox.widget {
    widget = wibox.container.margin,
    margins = 14,
    elems(),
  }

  local container = awful.popup {
    widget = wibox.container.background,
    ontop = true,
    visible = false,
    stretch = false,
    screen = s,
    shape = helpers.rrect(9),
    placement = awful.placement.centered,
    bg = beautiful.bg,
  }

  container:setup {
    winlist,
    layout = wibox.layout.fixed.vertical,
  }

  awesome.connect_signal("toggle::winswitch", function()
    container.visible = not container.visible
  end)
end

awful.screen.connect_for_each_screen(function(s)
  winswitch(s)
end)
