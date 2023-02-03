local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")

local stats = require("ui.notify.modules.stats")
local box = require("ui.notify.modules.notifs.box")
local height = 818

awful.screen.connect_for_each_screen(function(s)
  local notify = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = dpi(520),
    height = 1000,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  notify:setup {
    {
      nil,
      {
        box,
        margins = {
          bottom = 20,
        },
        widget = wibox.container.margin,
      },
      stats,
      layout = wibox.layout.align.vertical,
    },
    margins = dpi(20),
    widget = wibox.container.margin,
  }

  awful.placement.bottom_right(notify, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  awesome.connect_signal("toggle::notificationcenter", function()
    notify.visible = not notify.visible
  end)
end)
