local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local gears        = require("gears")
local helpers      = require("helpers")

local createHandle = function()
  return function(cr)
    gears.shape.rounded_rect(cr, 12, 12, 50)
  end
end

local slider       = wibox.widget {
  bar_shape           = helpers.rrect(20),
  bar_height          = 12,
  handle_color        = beautiful.pri,
  bar_color           = beautiful.fg3 .. '55',
  bar_active_color    = beautiful.pri,
  handle_shape        = createHandle(),
  handle_border_width = 0,
  handle_width        = dpi(12),
  handle_margins      = { top = 3 },
  handle_border_color = beautiful.bg2 .. 'cc',
  value               = 25,
  forced_height       = 18,
  maximum             = 50,
  widget              = wibox.widget.slider,
}
awesome.connect_signal("signal::padding", function(value)
  slider.value = value
end)
slider:connect_signal("property::value", function(_, value)
  awful.spawn.with_shell(
    'sed -i \'6s/.*/  gaps = ' .. value .. ',/g\' ~/.config/awesome/config/appearance.lua')
  awful.spawn.with_shell('bash -c "echo ' .. value .. ' > /tmp/barPadding"')
end)
return wibox.widget {
  {
    font = beautiful.font .. " 11",
    markup = helpers.colorizeText('Gaps', beautiful.fg3),
    valign = "center",
    widget = wibox.widget.textbox,
  },
  slider,
  layout = wibox.layout.fixed.vertical,
  spacing = 16,
}
