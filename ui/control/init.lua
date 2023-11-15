local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local buttons = require("ui.control.mods.buttons")
local sliders = require("ui.control.mods.slider")
local footer = require("ui.control.mods.footer")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    shape = helpers.rrect(12),
    screen = s,
    width = 520,
    height = 440,
    bg = beautiful.bg .. "00",
    ontop = true,
    visible = false,
  })

  control:setup {
    nil,
    {
      {
        {
          {

            {
              layout = wibox.layout.align.horizontal,
              {
                font = beautiful.sans .. " 14",
                markup = helpers.colorizeText("Control Center", beautiful.fg),
                widget = wibox.widget.textbox,
                valign = "center",
                align = "center"
              },
              nil,
              {
                {
                  {
                    font = beautiful.icon .. " 12",
                    markup = helpers.colorizeText("󰐱", beautiful.fg),
                    widget = wibox.widget.textbox,
                    valign = "center",
                    align = "center"
                  },
                  widget = wibox.container.margin,
                  margins = 10
                },
                widget = wibox.container.background,
                shape = helpers.rrect(6),
                buttons = {
                  awful.button({}, 1, function()
                    awesome.emit_signal('toggle::setup')
                  end)
                },
                bg = beautiful.mbg
              },
            },
            widget = wibox.container.margin,
            top = 18,
            left = 10,
            right = 10
          },
          buttons,
          sliders,
          footer,
          layout = wibox.layout.fixed.vertical,
          spacing = 20,
        },
        widget = wibox.container.margin,
        left = 20,
        right = 20,
      },
      widget = wibox.container.background,
      bg = beautiful.bg,
      shape = helpers.rrect(12),
    },
    nil,
    layout = wibox.layout.align.vertical,
    spacing = 8,
  }
  awful.placement.bottom_right(control, { honor_workarea = true, margins = 20 })
  awesome.connect_signal("toggle::control", function()
    control.visible = not control.visible
  end)
end)
