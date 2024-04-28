local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local module = require(... .. ".module")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    screen = s,
    width = 430,
    height = 325,
    shape = helpers.rrect(10),
    bg = beautiful.bg .. 00,
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      module.topsection,
      module.buttons,
      module.sliders,
      module.song,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
  }

  awesome.connect_signal("toggle::settings", function()
    control.visible = not control.visible
    awful.placement.top_left(control, { honor_workarea = true, margins = { left = 130, top = 15 } })
  end)
end)
