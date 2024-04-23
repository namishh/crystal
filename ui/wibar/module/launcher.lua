local beautiful = require('beautiful')
local wibox     = require("wibox")
local helpers   = require("helpers")
local awful     = require("awful")

-- Create a launcher widget. Opens the Awesome menu when clicked.
return function()
  return wibox.widget {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.awesome_icon,
        forced_height = 25,
        forced_width = 25,
        resize = true,
      },
      widget = wibox.container.margin,
      margins = 10,
    },
    widget = wibox.container.background,
    bg = beautiful.mbg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
    shape = helpers.rrect(5),
    buttons = {
      awful.button({}, 1, function()
        awesome.emit_signal('toggle::launcher')
      end)
    },
  }
end
