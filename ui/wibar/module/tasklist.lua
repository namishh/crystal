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
      layout = wibox.layout.fixed.vertical,
      spacing = 8,
    },
    style           = {
      shape = helpers.rrect(4),
    },
    widget_template = {
      {
        {
          id            = "icon_role",
          forced_height = dpi(20),
          widget        = wibox.widget.imagebox,
        },
        margins = 5,
        widget = wibox.container.margin,
      },
      id = "background_role",
      widget = wibox.container.background,
    }

  }
  return tasklst
end
