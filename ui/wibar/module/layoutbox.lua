local awful = require('awful')
local wibox = require("wibox")
local beautiful = require("beautiful")
local helpers = require('helpers')

return function(s)
  -- Create an imagebox widget which will contain an icon indicating which layout we're using.
  -- We need one layoutbox per screen.
  local layout = awful.widget.layoutbox({
    screen  = s,
    buttons = {
      awful.button(nil, 1, function() awful.layout.inc(1) end),
      awful.button(nil, 3, function() awful.layout.inc(-1) end),
      awful.button(nil, 4, function() awful.layout.inc(-1) end),
      awful.button(nil, 5, function() awful.layout.inc(1) end)
    }
  })
  local widget = {
    {
      {
        {
          {
            layout,
            clip_shape = helpers.rrect(3),
            widget = wibox.container.margin
          },
          margins = 4,
          widget = wibox.container.margin
        },
        bg = beautiful.mbg,
        forced_height = 30,
        forced_width = 30,
        widget = wibox.container.background
      },
      margins = 4,
      widget = wibox.container.margin
    },
    shape = helpers.rrect(5),
    bg = beautiful.mbg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
    widget = wibox.container.background
  }
  return widget
end
