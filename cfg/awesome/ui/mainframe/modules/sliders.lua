local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local createHandle = function()
  return function(cr)
    gears.shape.rounded_rect(cr, 12, 12, 50)
  end
end

local brightnessSlider = wibox.widget {
  bar_shape           = helpers.rrect(6),
  bar_height          = 3,
  handle_color        = beautiful.fg .. 'cc',
  bar_color           = beautiful.fg .. '33',
  bar_active_color    = beautiful.fg .. 'aa',
  handle_shape        = createHandle(),
  handle_border_width = 3,
  handle_width        = dpi(12),
  handle_margins      = { top = 12 },
  handle_border_color = beautiful.bg2 .. 'cc',
  value               = 25,
  forced_height       = 3,
  maximum             = 100,
  widget              = wibox.widget.slider,
}

local brightnessLabel = wibox.widget {
  font = beautiful.font .. " Bold 12",
  markup = "86" .. "%",
  valign = "center",
  widget = wibox.widget.textbox,
}


local brightnessLabelBox = wibox.widget {
  brightnessLabel,
  widget = wibox.container.margin,
  margins = {
    left = dpi(16),
  }
}

local brightnessIcon = wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 15",
        markup = helpers.colorizeText("󰃟", beautiful.fg .. 'cc'),
        valign = "center",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.margin,
      margins = 7,
    },
    bg = beautiful.fg .. '11',
    widget = wibox.container.background
  },
  widget = wibox.container.margin,
  margins = {
    right = dpi(16)
  }
}

local brightnessScale = wibox.widget {
  brightnessIcon,
  brightnessSlider,
  brightnessLabelBox,
  layout = wibox.layout.align.horizontal,
}



local volumeSlider = wibox.widget {
  bar_shape           = helpers.rrect(6),
  bar_height          = 3,
  handle_color        = beautiful.fg .. 'cc',
  bar_color           = beautiful.fg .. '33',
  bar_active_color    = beautiful.fg .. 'aa',
  handle_shape        = createHandle(),
  handle_border_width = 3,
  handle_width        = dpi(12),
  handle_margins      = { top = 12 },
  handle_border_color = beautiful.bg2 .. 'cc',
  value               = 25,
  forced_height       = 3,
  maximum             = 100,
  widget              = wibox.widget.slider,
}

local volumeLabel = wibox.widget {
  font = beautiful.font .. " Bold 12",
  markup = "86" .. "%",
  valign = "center",
  widget = wibox.widget.textbox,
}


local volumeLabelBox = wibox.widget {
  volumeLabel,
  widget = wibox.container.margin,
  margins = {
    left = dpi(16),
  }
}

local volumeIcon = wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 15",
        markup = helpers.colorizeText("󰕾", beautiful.fg .. 'cc'),
        valign = "center",
        widget = wibox.widget.textbox,
      },
      widget = wibox.container.margin,
      margins = 7,
    },
    bg = beautiful.fg .. '11',
    widget = wibox.container.background
  },
  widget = wibox.container.margin,
  margins = {
    right = dpi(16)
  }
}

local volumeScale = wibox.widget {
  volumeIcon,
  volumeSlider,
  volumeLabelBox,
  layout = wibox.layout.align.horizontal,
}

local finalwidget = wibox.widget {
  {
    {
      {
        font = beautiful.font .. " 11",
        markup = helpers.colorizeText('Controls', beautiful.fg3),
        valign = "center",
        widget = wibox.widget.textbox,
      },
      brightnessScale,
      volumeScale,
      spacing = 15,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = dpi(15)
  },

  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc'
}


awesome.connect_signal('signal::brightness', function(br)
  brightnessSlider.value = br
  brightnessLabel.markup = br .. '%'
end)

awesome.connect_signal('signal::volume', function(vol)
  volumeSlider.value = vol
  volumeLabel.markup = vol .. '%'
end)

volumeSlider:connect_signal("property::value", function(_, new_value)
  volumeLabel.markup = new_value .. "%"
  volumeSlider.value = new_value
  awful.spawn("pamixer --set-volume " .. new_value, false)
end)


brightnessSlider:connect_signal("property::value", function(_, new_value)
  brightnessSlider.markup = new_value .. "%"
  brightnessSlider.value = new_value
  awful.spawn("brightnessctl s " .. new_value .. "%", false)
end)

return finalwidget
