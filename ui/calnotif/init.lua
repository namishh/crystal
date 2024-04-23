local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local module = require(... .. '.module')

awful.screen.connect_for_each_screen(function(s)
  local calnotif = wibox({
    screen = s,
    width = 380,
    height = 760,
    bg = beautiful.bg .. 00,
    ontop = true,
    visible = false,
  })

  calnotif:setup {
    {
      {
        nil,
        {
          module.notifs,
          widget = wibox.container.margin,
          bottom = 15,
        },
        module.calendar(),
        layout = wibox.layout.align.vertical,
      },
      widget  = wibox.container.margin,
      margins = 15,
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
  }

  awesome.connect_signal("toggle::calnotif", function()
    calnotif.visible = not calnotif.visible
    awful.placement.bottom_right(calnotif, { honor_workarea = true, margins = { right = 6, bottom = 6 } })
  end)
end)
