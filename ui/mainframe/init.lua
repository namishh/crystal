local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")
local profile = require("ui.mainframe.modules.profile")
local sliders = require("ui.mainframe.modules.sliders")
local music = require("ui.mainframe.modules.music")
local settings = require("ui.mainframe.modules.settings")
-- not using footer at the moment

--local height = 720
awful.screen.connect_for_each_screen(function(s)
  local mainframe = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = 480,
    height = 725,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })
  mainframe:setup {
    {
      profile,
      sliders,
      music,
      settings,
      --footer,
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }
  local slide = animation:new({
    duration = 0.12,
    pos = s.geometry.height,
    easing = animation.easing.linear,
    update = function(_, pos)
      mainframe.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.33 + 0.08,
    callback = function()
      mainframe.visible = false
    end,
  })
  helpers.placeWidget(mainframe)
  awesome.connect_signal("toggle::dashboard", function()
    if mainframe.visible then
      slide_end:again()
      slide:set(s.geometry.height)
    elseif not mainframe.visible then
      slide:set(s.geometry.height - (mainframe.height + beautiful.useless_gap * 2))
      mainframe.visible = true
    end
  end)
  --   awesome.connect_signal("signal::toggler", function(val)
  --     if val then
  --       mainframe.height = dpi(mainframe.height + 98)
  --     else
  --       mainframe.height = dpi(1000)
  --       awful.placement.bottom_right(mainframe, { honor_workarea = true, margins = beautiful.useless_gap * 2 })
  --     end
  --   end)
end)
