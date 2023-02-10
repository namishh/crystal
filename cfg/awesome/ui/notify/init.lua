local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")

local notifbox = require("ui.notify.modules.notifs.box")

awful.screen.connect_for_each_screen(function(s)
  local moment = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = dpi(480),
    height = 800,
    bg = beautiful.bg,
    ontop = true,
    visible = false
  })


  moment:setup {
    {
      nil,
      notifbox,
      nil,
      layout = wibox.layout.align.vertical,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }

  awful.placement.bottom_right(moment, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  awesome.connect_signal("toggle::notify", function()
    moment.visible = not moment.visible
  end)

end)
