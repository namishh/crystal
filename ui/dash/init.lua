local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local module = require(... .. '.module')

awful.screen.connect_for_each_screen(function(s)
  local dash = wibox({
    screen = s,
    width = 1920,
    height = 1080,
    bg = beautiful.bg .. '99',
    ontop = true,
    visible = false,
  })

  dash:setup {
    {
      {
        {
          {
            module.weather,
            module.stat,
            layout = wibox.layout.fixed.vertical,
            spacing = 15,
          },
          {
            module.todo,
            module.song,
            layout = wibox.layout.fixed.vertical,
            spacing = 15,
          },
          {
            module.profile,
            module.nf,
            module.quote,
            layout = wibox.layout.fixed.vertical,
            spacing = 15,
          },
          spacing = 15,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = 15,
        widget = wibox.container.margin,
      },
      forced_width = 1440,
      forced_height = 760,
      widget = wibox.container.background,
      bg = beautiful.bg,
      shape = helpers.rrect(5),
      shape_border_width = 1,
      shape_border_color = beautiful.fg3,
    },
    widget = wibox.container.place,
    halign = 'center',
    valign = 'center',
  }

  awesome.connect_signal("toggle::dash", function()
    dash.visible = not dash.visible
    awful.placement.centered(dash, { honor_workarea = false })
  end)
end)
