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
    height = 530,
    bg = beautiful.bg .. 00,
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      ----
      module.topsection,
      {
        {
          widget = wibox.container.background,
          forced_height = 1,
          forced_width = 400,
          bg = beautiful.fg3
        },
        widget = wibox.container.place,
        halign = "center"
      },
      module.buttons,
      module.sliders,
      module.song,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
  }

  awesome.connect_signal("toggle::settings", function()
    control.visible = not control.visible
    awful.placement.bottom_right(control, { honor_workarea = true, margins = { right = 6, bottom = 6 } })
  end)
end)
