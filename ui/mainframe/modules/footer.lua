local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local timewidget = wibox.widget {
  font = beautiful.font .. " 12",
  format = "%I : %M",
  align = "center",
  valign = "center",
  widget = wibox.widget.textclock
}

local chev = wibox.widget {
  font = beautiful.icofont .. " 22",
  markup = "󰅀",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center",
  buttons = {
    awful.button({}, 1, function()
      awful.spawn.with_shell('~/.config/awesome/scripts/toggle --toggle')
    end)
  },
}


local batterylabel = wibox.widget {
  font = beautiful.font .. " 12",
  markup = "00%",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}

local batteryprog = wibox.widget {
  max_value     = 100,
  value         = 0,
  forced_height = dpi(7),
  forced_width  = dpi(30),
  paddings      = dpi(2),
  border_width  = dpi(2),
  shape         = helpers.rrect(3),
  bar_shape     = helpers.rrect(3),
  border_color  = beautiful.fg .. '96',
  widget        = wibox.widget.progressbar,
}

local batteryicon = wibox.widget {
  batteryprog,
  {
    {
      wibox.widget.textbox,
      widget = wibox.container.background,
      bg = beautiful.fg .. "96",
      forced_width = dpi(8.2),
      forced_height = dpi(8.2),
      shape = function(cr, width, height)
        gears.shape.pie(cr, width, height, 0, math.pi)
      end
    },
    direction = "east",
    widget = wibox.container.rotate()
  },
  layout = wibox.layout.fixed.horizontal,
}


local battery = wibox.widget {
  batteryicon,
  batterylabel,
  spacing = dpi(8),
  layout = wibox.layout.fixed.horizontal,
}

local finalwidget = wibox.widget {
  battery,
  chev,
  {
    {
      timewidget,
      widget = wibox.container.margin,
      margins = 1,
    },
    bg = beautiful.bg2 .. 'cc',
    widget = wibox.container.background
  },
  layout = wibox.layout.align.horizontal,
  widget = wibox.container.margin
}


awesome.connect_signal("signal::battery", function(value)
  batterylabel.markup = value .. "%"
  batteryprog.value = value
  if value > 90 then
    beautiful.progressbar_fg = beautiful.ok
  elseif value > 20 then
    beautiful.progressbar_fg = beautiful.pri
  else
    beautiful.progressbar_fg = beautiful.err
  end
end)
awesome.connect_signal("signal::toggler", function(val)
  if val then
    chev.markup = "󰅃"
  else
    chev.markup = "󰅀"
  end
end)
return finalwidget
