-- Status
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")

local wifi      = wibox.widget {
  font = beautiful.icofont .. " 14",
  markup = helpers.colorizeText("󰤨", beautiful.fg),
  widget = wibox.widget.textbox,
  valign = "center",
  align = "center"
}
local battery   = wibox.widget {
  id            = 'battery',
  widget        = wibox.widget.progressbar,
  max_value     = 100,
  value         = 69,
  forced_width  = 90,
  forced_height = 30,
  shape         = helpers.rrect(5),
}
local status    = wibox.widget {
  {
    {
      {
        {
          battery,
          {
            font = beautiful.icofont .. " 13",
            markup = helpers.colorizeText("󱐋", beautiful.bg),
            widget = wibox.widget.textbox,
            valign = "center",
            align = "center"
          },
          layout = wibox.layout.stack
        },
        wifi,
        layout = wibox.layout.fixed.horizontal,
        spacing = dpi(15)
      },
      left = 10,
      right = 10,
      top = 8,
      bottom = 6,
      widget = wibox.container.margin
    },
    layout = wibox.layout.stack
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::control')
    end)
  },
  bg = beautiful.bg2,
  widget = wibox.container.background,
  shape = helpers.rrect(2),
}

awesome.connect_signal("signal::network", function(value)
  if value then
    wifi.markup = "󰤨"
  else
    wifi.markup = helpers.colorizeText("󰤮", beautiful.fg2 .. "99")
  end
end)



awesome.connect_signal("signal::battery", function(value)
  local b = battery
  b.value = value
  if value < 20 then
    b.color = beautiful.err
    b.background_color = beautiful.err .. '55'
  elseif value < 50 then
    b.color = beautiful.warn
    b.background_color = beautiful.warn .. '55'
  elseif value < 70 then
    b.color = beautiful.pri
    b.background_color = beautiful.pri .. '55'
  else
    b.color = beautiful.ok
    b.background_color = beautiful.ok .. '55'
  end
end)

return status
