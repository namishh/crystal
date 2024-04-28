local beautiful = require('beautiful')
local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")

return wibox.widget {
  {
    widget = wibox.widget.imagebox,
    image = beautiful.pfp,
    forced_height = 40,
    forced_width = 40,
    clip_shape = helpers.rrect(100),
    resize = true,
    buttons = {
      awful.button({}, 1, function()
        awesome.emit_signal('toggle::launcher')
      end)
    },
  },
  widget = wibox.container.place,
  valign = "center",
}
