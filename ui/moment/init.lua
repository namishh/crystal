local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local calendar = require("ui.moment.mods.calendar")
local weather = require("ui.moment.mods.weather")
local clock = require("ui.moment.mods.clock")

awful.screen.connect_for_each_screen(function(s)
  local moment = wibox({
    shape = helpers.rrect(12),
    screen = s,
    width = 500,
    height = 1080 - 40 - 60,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  moment:setup {
    {
      {
        {
          {
            {
              markup = helpers.colorizeText("Time And Weather", beautiful.fg),
              halign = 'center',
              font   = beautiful.sans .. " 14",
              widget = wibox.widget.textbox
            },
            nil,
            nil,
            widget = wibox.layout.align.horizontal,
          },
          widget = wibox.container.margin,
          margins = 20,
        },
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      {
        {
          clock,
          calendar(),
          weather,
          layout = wibox.layout.fixed.vertical,
          spacing = 20,
        },
        widget = wibox.container.margin,
        margins = 20,
      },
      nil,
      layout = wibox.layout.align.vertical,
      spacing = 20,
    },
    widget = wibox.container.margin,
    margins = 0,
  }
  awful.placement.bottom_right(moment, { honor_workarea = true, margins = 20 })
  awesome.connect_signal("toggle::moment", function()
    moment.visible = not moment.visible
  end)
end)
