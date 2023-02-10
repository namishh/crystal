local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")

local calendar = require("ui.moment.modules.calendar")

awful.screen.connect_for_each_screen(function(s)
  local moment = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = dpi(355),
    height = 325,
    bg = beautiful.bg,
    ontop = true,
    visible = false
  })

  moment:setup {
    {
      nil,
      calendar,
      layout = wibox.layout.align.vertical,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }

  awful.placement.bottom_right(moment, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  awesome.connect_signal("toggle::moment", function()
    moment.visible = not moment.visible
  end)

end)
