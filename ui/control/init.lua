local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local buttons = require("ui.control.mods.buttons")
local moosic = require("ui.control.mods.music")
local sliders = require("ui.control.mods.slider")
local footer = require("ui.control.mods.footer")

awful.screen.connect_for_each_screen(function(s)
  local control = wibox({
    shape = helpers.rrect(8),
    screen = s,
    width = 520,
    height = 760,
    bg = beautiful.bg .. "00",
    ontop = true,
    visible = false,
  })

  control:setup {
    {
      {
        moosic,
        forced_height = 270,
        widget = wibox.container.background,
        bg = beautiful.bg,
        shape = helpers.rrect(12),
      },
      widget = wibox.container.margin,
      bottom = 20,
    },
    {
      {
        {
          {

            {
              layout = wibox.layout.align.horizontal,
              {
                {
                  widget = wibox.widget.imagebox,
                  image = beautiful.pfp,
                  forced_height = 50,
                  opacity = 0.7,
                  forced_width = 50,
                  clip_shape = helpers.rrect(8),
                  resize = true,
                },
                {
                  {
                    {
                      footer,
                      widget = wibox.container.place,
                      valign = "center",
                    },
                    widget = wibox.container.margin,
                    left = 10,
                    right = 10,
                  },
                  widget = wibox.container.background,
                  shape = helpers.rrect(5),
                  bg = beautiful.mbg
                },
                layout = wibox.layout.fixed.horizontal,
                spacing = 20,
              },
              nil,
              {
                {
                  {
                    font = beautiful.icon .. " 14",
                    markup = helpers.colorizeText("󰐱", beautiful.fg),
                    widget = wibox.widget.textbox,
                    valign = "center",
                    align = "center"
                  },
                  widget = wibox.container.margin,
                  margins = 15
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
          },
          sliders,
          buttons,
          layout = wibox.layout.fixed.vertical,
          spacing = 25,
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
  }
  awful.placement.bottom_right(control, { honor_workarea = true, margins = 20 })
  awesome.connect_signal("toggle::control", function()
    control.visible = not control.visible
  end)
end)
