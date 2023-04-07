-- Time Widget
local awful           = require("awful")
local wibox           = require("wibox")
local beautiful       = require("beautiful")
local dpi             = require("beautiful").xresources.apply_dpi
local helpers         = require("helpers")
local hourminutes     = wibox.widget {
  {
    {
      font = beautiful.font,
      format = "%I : %M",
      align = "center",
      valign = "center",
      widget = wibox.widget.textclock
    },
    margins = { left = dpi(5), right = dpi(5) },
    widget = wibox.container.margin
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::moment')
    end)
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
}

local finaltimewidget = wibox.widget {
  {
    hourminutes,
    layout = wibox.layout.fixed.horizontal,
  },
  spacing = 6,
  layout = wibox.layout.fixed.horizontal,
}

return finaltimewidget
