local awful = require 'awful'
require 'awful.autofocus'
local wibox      = require 'wibox'
local gears      = require 'gears'
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local beautiful  = require("beautiful")
local ruled      = require("ruled")
client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )
  awful.titlebar(c, {
    size = 30,
  }):setup {
    {
      { -- Right
        {
          awful.titlebar.widget.closebutton(c),
          awful.titlebar.widget.maximizedbutton(c),
          awful.titlebar.widget.minimizebutton(c),
          spacing = dpi(8),
          layout = wibox.layout.fixed.horizontal
        },
        top = dpi(5),
        bottom = dpi(5),
        widget = wibox.container.margin
      },
      { -- Middle
        buttons = buttons,
        layout  = wibox.layout.flex.horizontal
      },
      { -- Left
        { -- Title
          {
            align  = 'center',
            widget = awful.titlebar.widget.titlewidget(c)
          },
          widget = wibox.container.constraint,
          width = dpi(350)

        },
        -- awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal
    },
    right = dpi(10),
    left = dpi(10),
    top = dpi(0),
    bottom = dpi(5),
    widget = wibox.container.margin
  }
end)
