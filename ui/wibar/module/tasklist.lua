local awful     = require('awful')
local beautiful = require('beautiful')
local wibox     = require("wibox")
local helpers   = require("helpers")
local dpi       = beautiful.xresources.apply_dpi

return function(s)
  local tasklst = awful.widget.tasklist {
    screen          = s,
    filter          = awful.widget.tasklist.filter.currenttags,
    buttons         = {
      awful.button({}, 1, function(c)
        c:activate { context = "tasklist", action = "toggle_minimization" }
      end),
    },
    layout          = {
      layout = wibox.layout.fixed.horizontal,
      spacing = 8,
    },
    style           = {
      shape = helpers.rrect(4),
      shape_border_width = 1,
      shape_border_color = beautiful.fg3,
    },
    widget_template = {
      {
        {
          {
            id            = "text_role",
            forced_height = dpi(20),
            widget        = wibox.widget.textbox,
          },
          widget = wibox.container.constraint,
          width = dpi(300),
          forced_width = dpi(200),
        },
        margins = {
          left = dpi(10),
          right = dpi(10)
        },
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    }

  }
  return tasklst
end
