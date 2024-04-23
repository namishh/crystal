local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local hourminutes = wibox.widget {
  {
    {
      {
        font = beautiful.sans,
        format = "%I : %M",
        align = "center",
        valign = "center",
        widget = wibox.widget.textclock
      },
      widget = wibox.container.place,
      valign = "center"
    },
    margins = { left = dpi(10), right = dpi(10) },
    widget = wibox.container.margin
  },
  bg = beautiful.mbg,
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::calnotif')
    end)
  },
  widget = wibox.container.background,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
}

return hourminutes
