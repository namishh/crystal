local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local gears        = require("gears")
local helpers      = require("helpers")

local createHandle = function()
  return function(cr)
    gears.shape.rounded_rect(cr, 17, 17, 15)
  end
end

local createSlider = function(signal, command)
  local slidSlider = wibox.widget {
    bar_shape           = helpers.rrect(25),
    bar_height          = 6,
    handle_color        = beautiful.bg,
    bar_color           = beautiful.fg3,
    bar_active_color    = beautiful.fg,
    handle_shape        = createHandle(),
    handle_border_width = 2,
    handle_width        = dpi(20),
    handle_margins      = { top = 8 },
    handle_border_color = beautiful.fg3,
    value               = 25,
    forced_height       = 35,
    maximum             = 100,
    widget              = wibox.widget.slider,
  }

  local slidLabel  = wibox.widget {

    font = beautiful.sans .. " Bold 12",
    markup = "86" .. "%",
    valign = "center",
    widget = wibox.widget.textbox,
  }


  local img = gears.color.recolor_image(
    gears.filesystem.get_configuration_dir() .. "theme/icons/settings/" .. signal .. ".svg", beautiful.fg)
  local slidIcon = wibox.widget {
    {
      widget = wibox.widget.imagebox,
      image = img,
      forced_height = 25,
      forced_width = 25,
      resize = true,
      id = "image",
    },
    widget = wibox.container.margin,
  }

  local slidScale = wibox.widget {
    nil,
    {
      {
        slidIcon,
        widget = wibox.container.place,
        valign = "center",
        halign = "left"
      },
      {
        {
          {
            widget = wibox.container.background,
            forced_height = 2,
            shape = helpers.rrect(10),
            bg = beautiful.mbg
          },
          widget = wibox.container.place,
          content_fill_horizontal = true,
          valign = "center",
        },
        slidSlider,
        layout = wibox.layout.stack,
      },
      layout = wibox.layout.fixed.horizontal,
      spacing = 15
    },
    nil,
    layout = wibox.layout.align.horizontal,
  }

  awesome.connect_signal('signal::' .. signal, function(value)
    slidSlider.value = value
  end)
  slidSlider:connect_signal("property::value", function(_, new_value)
    awful.spawn.with_shell(string.format(command, new_value))
  end)
  return slidScale
end

local widget       = wibox.widget {
  {
    {
      {
        {
          markup = helpers.colorizeText("Sliders", beautiful.fg2),
          font = beautiful.sans .. " 12",
          widget = wibox.widget.textbox,
        },
        {
          createSlider("brightness", "brightnessctl s %d%%"),
          createSlider("volume", "pamixer --set-volume %d"),
          layout = wibox.layout.fixed.vertical,
          spacing = 15,
        },
        layout = wibox.layout.fixed.vertical,
        spacing = 15,
      },
      widget = wibox.container.margin,
      margins = 15,
    },
    widget = wibox.container.background,
    id = "bg",
    bg = beautiful.mbg,
    shape_border_color = beautiful.fg3,
    shape = helpers.rrect(5),
    shape_border_width = 1,
  },
  widget = wibox.container.margin,
  margins = 15,
}

return widget
