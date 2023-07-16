local wibox          = require("wibox")
local beautiful      = require("beautiful")
local dpi            = require("beautiful").xresources.apply_dpi
local helpers        = require("helpers")
local awful          = require('awful')

local profilepicture = wibox.widget {
  image         = beautiful.profilepicture,
  opacity       = 0.65,
  clip_shape    = helpers.rrect(4),
  forced_height = 80,
  forced_width  = 80,
  widget        = wibox.widget.imagebox
}
local uptime         = wibox.widget {
  halign = "right",
  font = beautiful.font .. " 11",
  markup = helpers.colorizeText("4h 45m", beautiful.fg3),
  widget = wibox.widget.textbox,
}
local name           = wibox.widget {
  nil,
  {
    {
      halign = "right",
      font = beautiful.font .. " Bold 14",
      markup = helpers.colorizeText("Welcome!", beautiful.fg .. 'cc'),
      widget = wibox.widget.textbox,
    },
    {
      halign = "right",
      font = beautiful.font .. " 13",
      markup = "chadcat#5207",
      widget = wibox.widget.textbox,
    },
    spacing = 3,
    layout = wibox.layout.fixed.vertical,
  },
  layout = wibox.layout.align.vertical,
  expand = "none"
}
local batval         = wibox.widget {
  font = beautiful.font .. " 13",
  markup = helpers.colorizeText("15", beautiful.pri),
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
}
local battery        = wibox.widget {
  batval,
  widget = wibox.container.arcchart,
  max_value = 100,
  min_value = 0,
  value = 69,
  rounded_edge = true,
  thickness = dpi(4.5),
  start_angle = 4.71238898,
  bg = beautiful.pri .. "4D",
  colors = { beautiful.pri },
  forced_width = dpi(70),
  forced_height = dpi(70)
}

local finalwidget    = wibox.widget {
  {
    {

      profilepicture,
      nil,
      {
        uptime,
        name,
        spacing = 5,
        layout = wibox.layout.fixed.vertical
      },
      spacing = 70,
      layout = wibox.layout.align.horizontal,
    },
    margins = 25,
    widget = wibox.container.margin,
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background
}

awesome.connect_signal("signal::battery", function(value)
  batval.markup = helpers.colorizeText(tostring(value), beautiful.pri)
  battery.value = value
end)

awesome.connect_signal("signal::uptime", function(value)
  uptime.markup = helpers.colorizeText(value, beautiful.fg3)
end)
return finalwidget
