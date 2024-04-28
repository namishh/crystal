local awful = require('awful')
local wibox = require('wibox')
local beautiful = require("beautiful")
local gears = require("gears")
--- The titlebar to be used on normal clients.
return function(c)
  -- Draws the client titlebar at the default position (top) and size.

  local get_titlebar = function(c)
    local buttons = gears.table.join({
      awful.button({}, 1, function()
        c:activate { context = "titlebar", action = "mouse_move" }
      end),
      awful.button({}, 3, function()
        c:activate { context = "titlebar", action = "mouse_resize" }
      end)
    })



    local container = wibox.widget {
      bg = beautiful.mbg,
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
      widget = wibox.container.background,
    }


    return wibox.widget({
      {
        {
          layout = wibox.layout.align.vertical,
          -- Right
          {
            {
              layout = wibox.layout.fixed.vertical,
              spacing = 15,
              awful.titlebar.widget.closebutton(c),
              awful.titlebar.widget.maximizedbutton(c),
            },
            widget = wibox.container.margin,
            margins = 5,
          },
          -- Middle
          {
            buttons = buttons,
            layout = wibox.layout.fixed.vertical,
          },

          {
            buttons = buttons,
            layout = wibox.layout.fixed.vertical,
          },
        },
        widget = wibox.container.margin,
        margins = 5,
      },
      widget = container,

    })
  end

  local function top(c)
    local titlebar = awful.titlebar(c, {
      position = 'left',
      size = 40,
      bg = "#00000000"
    })

    titlebar:setup {
      widget = get_titlebar(c)
    }
  end

  client.connect_signal("request::titlebars", function(c)
    top(c)
  end)
end
