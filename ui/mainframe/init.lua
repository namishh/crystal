local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")
local profile = require("ui.mainframe.modules.profile")
local search = require("ui.mainframe.modules.search")
local music = require("ui.mainframe.modules.music")
local taw = require("ui.mainframe.modules.taw")
local notifbox = require("ui.mainframe.modules.notifs.box")
local bardir = beautiful.barDir
-- not using footer at the moment
local set
local h
local w
if bardir == 'left' or bardir == 'right' then
  set = {
    search,
    taw,
    profile,
    music,
    notifbox,
    spacing = 20,
    layout = wibox.layout.fixed.vertical,
  }
  w = 480
  h = beautiful.scrheight - beautiful.useless_gap * 4
else
  set = {
    {
      search,
      taw,
      profile,
      music,
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    notifbox,
    spacing = 20,
    layout = wibox.layout.fixed.horizontal,
  }
  w = 960
  h = 760
end
--local height = 720
awful.screen.connect_for_each_screen(function(s)
  local mainframe = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = w,
    height = h,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })
  mainframe:setup {
    set,
    margins = dpi(15),
    widget = wibox.container.margin,
  }

  helpers.placeWidget(mainframe)
  local slide = animation:new({
    duration = 0.5,
    pos = 0 - mainframe.height,
    easing = animation.easing.linear,
    update = function(_, pos)
      mainframe.y = s.geometry.y + pos
    end,
  })

  local slide_end = gears.timer({
    single_shot = true,
    timeout = 0.43 + 0.08,
    callback = function()
      mainframe.visible = false
    end,
  })
  awesome.connect_signal("toggle::dashboard", function()
    local pad = 0
    if beautiful.barShouldHaveGaps then
      pad = beautiful.barPadding
    end
    if mainframe.visible then
      slide_end:again()
      slide:set(0 - mainframe.height)
    elseif not mainframe.visible then
      if beautiful.barDir == 'top' then
        slide:set(beautiful.barSize + beautiful.useless_gap + math.ceil(pad / 2))
      elseif beautiful.barDir == 'bottom' then
        slide:set(s.geometry.height - mainframe.height - beautiful.barSize - beautiful.useless_gap - math.ceil(pad / 2))
      else
        slide:set(s.geometry.height - (mainframe.height + beautiful.useless_gap * 2))
      end
      mainframe.visible = true
    end
  end)
end)
