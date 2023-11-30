local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local hourminutes = wibox.widget {
  {
    {
      {
        {
          font = beautiful.sans .. " 15",
          format = "%I : %M",
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        widget = wibox.container.place,
        valign = "center"
      },
      {
        {
          font = beautiful.sans .. " 12",
          format = "%d %B",
          align = "center",
          valign = "center",
          widget = wibox.widget.textclock
        },
        widget = wibox.container.place,
        valign = "center"
      },
      layout = wibox.layout.fixed.horizontal,
      spacing = 20
    },
    margins = { left = dpi(10), right = dpi(10) },
    widget = wibox.container.margin
  },
  bg = beautiful.mbg,
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::moment')
    end)
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
}

return hourminutes
