local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local createSlider = function(label, value)
  local text = wibox.widget {
    {
      font = beautiful.font .. " 12",
      markup = label,
      widget = wibox.widget.textbox,
      valign = "center",
      align = "center"
    },
    widget = wibox.container.margin,
  }
  local progress = wibox.widget {
    widget = wibox.container.arcchart,
    max_value = 100,
    min_value = 0,
    value = value,
    thickness = dpi(7),
    rounded_edge = true,
    bg = beautiful.pri .. "4D",
    colors = { beautiful.pri },
    start_angle = math.pi + math.pi / 2,
    forced_width = dpi(72),
    forced_height = dpi(72)
  }
  local widget = wibox.widget {
    {
      {
        {
          {
            text,
            halign = 'left',
            widget = wibox.container.place,
          },
          {
            progress,
            widget = wibox.container.margin,
          },
          spacing = 29,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.margin,
        margins = 10
      },
      widget = wibox.container.background,
      bg = beautiful.bg2 .. 'cc',
    },
    forced_height = 150,
    forced_width = 140,
    widget = wibox.container.margin,
  }
  return widget
end

local memory = createSlider('Mem', 69)
local disk = createSlider('Disk', 12)
local cpu = createSlider('Cpu', 34)

local finalwidget = wibox.widget {
  memory,
  cpu,
  disk,
  expand = 'none',
  layout = wibox.layout.align.horizontal,
}

return finalwidget
