local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")
local awful     = require('awful')

return wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 16",
        markup = helpers.colorizeText("󰝥", beautiful.err),
        widget = wibox.widget.textbox,
        align = "left",
        valign = "center",
        buttons =
        {
          awful.button({}, 1, function() awesome.emit_signal('toggle::moment') end),
        }
      },
      nil,
      {
        font = beautiful.font .. " 12",
        markup = helpers.colorizeText("MOMENT", beautiful.fg),
        widget = wibox.widget.textbox,
        align = "right",
        valign = "center",
      },
      layout = wibox.layout.align.horizontal
    },
    widget = wibox.container.margin,
    margins = 15,
  },
  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc'
}
