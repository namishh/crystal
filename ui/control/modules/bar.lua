local wibox       = require("wibox")
local awful       = require("awful")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")

local titleButton = function(id, name)
  local titleText = wibox.widget {
    align = 'center',
    font = beautiful.font .. " 11",
    markup = name,
    widget = wibox.widget.textbox,
  }
  local widget = wibox.widget {
    {
      {
        {
          titleText,
          layout = wibox.layout.fixed.vertical,
        },
        widget = wibox.container.place,
        align = 'center'
      },
      widget = wibox.container.margin,
      margins = 10,
    },
    shape = helpers.rrect(3),
    widget = wibox.container.background,
    bg = beautiful.fg3 .. '33'
  }
  widget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell(
      'sed -i \'4s/.*/  barDir = "' .. id .. '",/g\' ~/.config/awesome/config/appearance.lua')
    awful.spawn.with_shell('bash -c "echo ' .. id .. ' > /tmp/barDir"')
  end))
  awesome.connect_signal("signal::bardir", function(val)
    widget.bg = beautiful.fg3 .. '33'
    titleText.markup = helpers.colorizeText(name, beautiful.fg)
    if val == string.lower(id) then
      widget.bg = beautiful.pri
      titleText.markup = helpers.colorizeText(name, beautiful.bg)
    end
  end)
  return widget
end

local top         = titleButton("top", "Top")
local bottom      = titleButton("bottom", "Bot")
local left        = titleButton("left", "Left")
local right       = titleButton("right", "Right")
local finalwidget = wibox.widget {
  {
    {
      font = beautiful.font .. " 11",
      markup = helpers.colorizeText('Bar Direction', beautiful.fg3),
      valign = "center",
      widget = wibox.widget.textbox,
    },
    {
      top,
      bottom,
      left,
      right,
      layout = wibox.layout.fixed.horizontal,
      spacing = 10,
    },
    spacing = 15,
    layout = wibox.layout.fixed.vertical
  },
  widget = wibox.container.margin,
}


return finalwidget
