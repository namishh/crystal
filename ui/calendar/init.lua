local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local module = require(... .. '.module')

awful.screen.connect_for_each_screen(function(s)
  local calendar = wibox({
    screen = s,
    width = 380,
    height = 440,
    bg = beautiful.bg .. 00,
    ontop = true,
    shape = helpers.rrect(10),
    visible = false,
  })

  calendar:setup {
    {
      {
        {
          {
            markup = helpers.colorizeText("Calendar", beautiful.magenta),
            font   = beautiful.sans .. " 12",
            widget = wibox.widget.textbox
          },
          widget  = wibox.container.margin,
          margins = 15,
        },
        widget = wibox.container.background,
        bg = beautiful.magenta .. '11',
      },
      {
        module.calendar(),
        widget  = wibox.container.margin,
        margins = 15,
      },
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.background,
    bg = beautiful.bg,
  }

  awesome.connect_signal("toggle::calendar", function()
    calendar.visible = not calendar.visible
    awful.placement.top_left(calendar, { honor_workarea = true, margins = { left = 180, top = 15 } })
  end)
end)
