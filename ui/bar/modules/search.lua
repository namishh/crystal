local beautiful = require('beautiful')
local wibox = require('wibox')
local awful = require('awful')
local helpers = require('helpers')

local horizwidget = wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 17",
        markup = helpers.colorizeText("󰍉", beautiful.pri),
        widget = wibox.widget.textbox,
        valign = "center",
        align = "center"
      },
      {
        id = "search",
        font = beautiful.font .. " 11",
        markup = "Search",
        widget = wibox.widget.textbox,
        valign = "center",
        align = "center"
      },
      spacing = 10,
      layout = wibox.layout.fixed.horizontal
    },
    widget = wibox.container.margin,
    margins = 7,
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal("toggle::launcher")
    end)
  },
  forced_width = 180,
  shape = helpers.rrect(4),
  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc'
}

local widget = horizwidget
return widget
