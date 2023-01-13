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
  markup = "86%",
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}

local batteryprog = wibox.widget {
  max_value     = 100,
  value         = 86,
  forced_height = dpi(3),
  forced_width  = dpi(35),
  paddings      = dpi(1),
  border_width  = dpi(1),
  shape         = helpers.rrect(3),
  bar_shape     = helpers.rrect(3),
  border_color  = beautiful.fg .. 'cc',
  widget        = wibox.widget.progressbar,
}

local batteryicon = wibox.widget {
  batteryprog,
  {
    {
      wibox.widget.textbox,
      widget = wibox.container.background,
      bg = beautiful.fg .. "A6",
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
  timewidget,
  layout = wibox.layout.align.horizontal,
  widget = wibox.container.margin
}

awesome.connect_signal("signal::toggler", function(val)
  if val then
    chev.markup = "󰅃"
  else
    chev.markup = "󰅀"
  end
end)
return finalwidget
