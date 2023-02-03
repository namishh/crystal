local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local createSlider = function(label, color, value)
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
  local teextval = wibox.widget {
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
    bg = color .. "4D",
    colors = { color },
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
    forced_height = 160,
    forced_width = 150,
    widget = wibox.container.margin,
  }
  return widget
end

local memory = createSlider('Mem', beautiful.err, 69)
local disk = createSlider('Disk', beautiful.ok, 12)
local cpu = createSlider('Cpu', beautiful.pri, 34)

local finalwidget = wibox.widget {
  memory,
  cpu,
  disk,
  expand = 'none',
  spacing = 20,
  layout = wibox.layout.fixed.horizontal,
}

return finalwidget
