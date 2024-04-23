local beautiful = require('beautiful')
local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")

return wibox.widget {
  {
    widget = wibox.widget.imagebox,
    image = beautiful.pfp,
    forced_height = 30,
    forced_width = 30,
    clip_shape = helpers.rrect(100),
    resize = true,
    buttons = {
      awful.button({}, 1, function()
        awesome.emit_signal('toggle::powermenu')
      end)
    },
  },
  widget = wibox.container.place,
  valign = "center",
}
