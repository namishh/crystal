local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local awful       = require('awful')

local midText     = wibox.widget {
  halign = 'center',
  font = beautiful.icofont .. " 20",
  markup = helpers.colorizeText(" ", beautiful.fg3),
  widget = wibox.widget.textbox,
}

local createProg  = function(color, signal, size, icon)
  local progress = wibox.widget {
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    padding = 0,
    value = 100,
    rounded_edge = false,
    thickness = 16,
    start_angle = 4.71238898,
    colors = { color },
    bg = color .. '11',
    forced_width = dpi(size),
    forced_height = dpi(size)
  }
  awesome.connect_signal('signal::' .. signal, function(val)
    progress.value = val
  end)
  progress:connect_signal('mouse::enter', function()
    midText.markup = helpers.colorizeText(icon, color)
  end)
  progress:connect_signal('mouse::leave', function()
    midText.markup = helpers.colorizeText(' ', color)
  end)
  return {
    { progress, layout = wibox.layout.fixed.vertical },
    widget = wibox.container.place,
    valign = 'center',
    halign = 'center'
  }
end
local batteryprog = createProg(beautiful.ok, 'battery', 85, "󰁹")
local memprog     = createProg(beautiful.warn, 'memory', 135, "󰍛")
local diskprog    = createProg(beautiful.err, 'disk', 185, "󰋊")
local cpuprog     = createProg(beautiful.dis, 'cpu', 235, '󰘚')

local finalwidget = wibox.widget {
  {
    {
      {
        {
          {
            midText,
            widget = wibox.container.place,
            halign = 'center',
            valign = 'center',
          },
          batteryprog,
          memprog,
          diskprog,
          cpuprog,
          layout = wibox.layout.stack
        },
        spacing = 10,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place,
      valign = 'center'
    },
    widget = wibox.container.margin,
    margins = 20
  },
  forced_width = 300,
  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc'
}

return finalwidget
