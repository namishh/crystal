local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local animation = require("modules.rubato")
local beautiful = require("beautiful")
return function(s)
  local taglist = awful.widget.taglist {
    layout          = {
      layout = wibox.layout.fixed.horizontal,
    },
    screen          = s,
    filter          = awful.widget.taglist.filter.all,
    buttons         = {
      awful.button({}, 1, function(t) t:view_only() end)
    },
    widget_template = {
      {
        {
          id     = 'text_role',
          widget = wibox.widget.textbox,
        },
        margins = {
          left = 12,
          right = 12
        },
        widget  = wibox.container.margin,
      },
      id     = 'background_role',
      widget = wibox.container.background,
    }
  }
  return taglist
end
