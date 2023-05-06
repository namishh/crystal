local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")

local calendar = require("ui.moment.modules.calendar")()
local weather = require("ui.moment.modules.weather")

awful.screen.connect_for_each_screen(function(s)
  local moment = wibox({
    type = "dock",
    screen = s,
    width = dpi(720),
    shape = helpers.rrect(8),
    height = dpi(410),
    bg = beautiful.bg,
    ontop = true,
    visible = false
  })

  local slide = animation:new({
    duration = 0.6,
    pos = 0 - moment.height,
    easing = animation.easing.inOutExpo,
    update = function(_, pos)
      moment.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43 + 0.08,
    callback = function()
      moment.visible = false
    end,
  })
  moment:setup {
    {
      calendar,
      weather,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }
  helpers.placeWidget(moment)
  awesome.connect_signal("toggle::moment", function()
    if moment.visible then
      slide_end:again()
      slide:set(0 - moment.height)
    elseif not moment.visible then
      slide:set(beautiful.barSize + beautiful.useless_gap)
      moment.visible = true
    end
  end)
end)
