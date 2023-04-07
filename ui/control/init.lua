local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")

local sliders = require("ui.control.modules.sliders")
local settings = require("ui.control.modules.settings")
local themer = require("ui.control.modules.themer")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = 480,
    height = 635,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      sliders,
      settings,
      themer,
      layout = wibox.layout.fixed.vertical,
      spacing = 20,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }
  local slide = animation:new({
    duration = 0.5,
    pos = 0 - control.height,
    easing = animation.easing.linear,
    update = function(_, pos)
      control.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43,
    callback = function()
      control.visible = false
    end,
  })
  awful.placement.bottom_right(control, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  awesome.connect_signal("toggle::control", function()
    local pad = 0
    if beautiful.barShouldHaveGaps then
      pad = beautiful.barPadding
    end
    if control.visible then
      slide_end:again()
      slide:set(0 - control.height)
    elseif not control.visible then
      slide:set(beautiful.barSize + beautiful.useless_gap + math.ceil(pad / 2))
      control.visible = true
    end
  end)
end)
