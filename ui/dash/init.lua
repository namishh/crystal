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
    width = 550,
    height = 1050,
    type = "dock",
    bg = beautiful.bg .. 00,
    ontop = true,
    shape = helpers.rrect(10),
    visible = false,
  })

  dash:setup {
    module.fetch,
    {
      module.song,
      module.progs,
      spacing = 20,
      layout = wibox.layout.fixed.horizontal,
    },
    spacing = 20,
    layout = wibox.layout.fixed.vertical,
  }

  awesome.connect_signal("toggle::dash", function()
    dash.visible = not dash.visible
    awful.placement.top_right(dash, { honor_workarea = false, margins = 15 })
  end)
end)
