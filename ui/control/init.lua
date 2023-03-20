local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.animation")

local sliders = require("ui.control.modules.sliders")
local barpadding = require("ui.control.modules.barpadding")
local settings = require("ui.control.modules.settings")
local themer = require("ui.control.modules.themer")
local title = require("ui.control.modules.titlebar")
local bar = require("ui.control.modules.bar")
local bargaps = require("ui.control.modules.bargaps")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    type = "dock",
    shape = helpers.rrect(4),
    screen = s,
    width = 480,
    height = 890,
    bg = beautiful.bg,
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      sliders,
      settings,
      themer,
      {
        {
          {
            {
              title,
              bar,
              spacing = 25,
              layout = wibox.layout.fixed.horizontal
            },
            {
              barpadding,
              spacing = 25,
              layout = wibox.layout.fixed.horizontal
            },
            {
              bargaps,
              nil,
              {
                {
                  {
                    font = beautiful.font .. " 12",
                    markup = helpers.colorizeText('Apply', beautiful.pri),
                    valign = "center",
                    widget = wibox.widget.textbox,
                  },
                  widget = wibox.container.margin,
                  margins = 4,
                },
                buttons = {
                  awful.button({}, 1, function()
                    awesome.restart()
                  end)
                },
                widget = wibox.container.background,
                bg = beautiful.pri .. '11'
              },
              layout = wibox.layout.align.horizontal
            },
            spacing = 20,
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.margin,
          margins = 15,
        },
        widget = wibox.container.background,
        bg = beautiful.bg2 .. 'cc'
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical
    },
    margins = dpi(15),
    widget = wibox.container.margin,
  }
  local slide = animation:new({
    duration = 0.5,
    pos = s.geometry.height + 500,
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
    if control.visible then
      slide_end:again()
      slide:set(s.geometry.height)
    elseif not control.visible then
      if beautiful.barDir == 'top' then
        slide:set(s.geometry.height - beautiful.scrheight + beautiful.barSize + beautiful.useless_gap * 4)
      elseif beautiful.barDir == 'bottom' then
        slide:set(s.geometry.height - (control.height + beautiful.useless_gap * 2) - beautiful.barSize)
      else
        slide:set(s.geometry.height - (control.height + beautiful.useless_gap * 2))
      end
      control.visible = true
    end
  end)
end)
