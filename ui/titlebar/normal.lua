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
      bg = beautiful.bg,
      shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
      shape_border_width = 1,
      shape_border_color = beautiful.fg3,
      widget = wibox.container.background,
    }

    local image = wibox.widget {

      widget = wibox.widget.imagebox,
      image = beautiful.titlebar_left,
      id = "image",
      resize = true,
    }

    c:connect_signal("focus", function() image.opacity = 1 end)
    c:connect_signal("unfocus", function() image.opacity = 0.3 end)

    return wibox.widget({
      {
        {
          layout = wibox.layout.align.horizontal,
          -- Left
          {
            {

              image,
              layout = wibox.layout.fixed.horizontal,
            },
            widget = wibox.container.margin,
            margins = 5,
          },
          -- Middle
          {
            buttons = buttons,
            layout = wibox.layout.fixed.horizontal,
          },
          -- Right
          {
            {
              layout = wibox.layout.fixed.horizontal,
              spacing = 15,
              awful.titlebar.widget.minimizebutton(c),
              awful.titlebar.widget.maximizedbutton(c),
              awful.titlebar.widget.closebutton(c)
            },
            widget = wibox.container.margin,
            margins = 7,
          }
        },
        widget = wibox.container.margin,
        margins = 5,
      },
      widget = container,

    })
  end

  local function top(c)
    local titlebar = awful.titlebar(c, {
      position = 'top',
      size = 50,
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
