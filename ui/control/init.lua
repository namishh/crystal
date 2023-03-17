local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")

local sliders = require("ui.control.modules.sliders")
local settings = require("ui.control.modules.settings")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = 480,
    height = 800,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      sliders,
      settings,
      spacing = 20,
      layout = wibox.layout.fixed.vertical
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }
  local slide = animation:new({
    duration = 0.5,
    pos = s.geometry.height,
    easing = animation.easing.linear,
    update = function(_, pos)
      control.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43 + 0.08,
    callback = function()
      control.visible = false
    end,
  })
  awful.placement.bottom_right(control, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  awesome.connect_signal("toggle::control", function()
    if control.visible then
      slide_end:again()
      slide:set(s.geometry.height)
    elseif not control.visible then
      if beautiful.barDir == 'top' then
        slide:set(s.geometry.height - beautiful.scrheight + 62)
      elseif beautiful.barDir == 'bottom' then
        slide:set(s.geometry.height - (control.height + beautiful.useless_gap * 4) - beautiful.barSize)
      else
        slide:set(s.geometry.height - (control.height + beautiful.useless_gap * 2))
      end
      control.visible = true
    end
  end)
end)
