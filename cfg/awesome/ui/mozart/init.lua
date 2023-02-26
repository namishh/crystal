local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = beautiful.xresources.apply_dpi
local helpers   = require("helpers")
local wibox     = require("wibox")

local stuff     = require("ui.mozart.modules.song")

awful.screen.connect_for_each_screen(function(s)
  local mozart = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = dpi(540),
    height = dpi(270),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  })

  mozart:setup {
    stuff,
    widget = wibox.container.margin,
  }

  helpers.placeWidget(mozart)
  awesome.connect_signal("toggle::mozart", function()
    mozart.visible = not mozart.visible
  end)
end)
