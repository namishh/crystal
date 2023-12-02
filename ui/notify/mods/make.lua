-- the notification themselves
local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
return function(icon, n)
  local time = os.date "%H:%M:%S"

  local icon_widget = wibox.widget {
    widget = wibox.container.constraint,
    {
      widget = wibox.container.margin,
      margins = 20,
      {
        widget = wibox.widget.imagebox,
        image = helpers.cropSurface(1, gears.surface.load_uncached(icon)),
        resize = true,
        clip_shape = gears.shape.circle,
        halign = "center",
        valign = "center",
      },
    },
  }

  local title_widget = wibox.widget {
    widget = wibox.container.scroll.horizontal,
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    forced_width = 200,
    {
      widget = wibox.widget.textbox,
      text = n.title,
      align = "left",
      forced_width = 200,
    },
  }

  local time_widget = wibox.widget {
    widget = wibox.container.margin,
    margins = { right = 4 },
    {
      widget = wibox.widget.textbox,
      text = time,
      align = "right",
      valign = "bottom",
    },
  }

  local text_notif = wibox.widget {
    markup = n.message,
    align = "left",
    forced_width = 165,
    widget = wibox.widget.textbox,
  }


  local box = wibox.widget {
    widget = wibox.container.background,
    forced_height = 120,
    bg = beautiful.mbg,
    {
      layout = wibox.layout.align.horizontal,
      icon_widget,
      {
        widget = wibox.container.margin,
        margins = 10,
        {
          layout = wibox.layout.align.vertical,
          {
            layout = wibox.layout.fixed.vertical,
            expand = "none",
            spacing = 10,
            {
              layout = wibox.layout.align.horizontal,
              title_widget,
              nil,
              time_widget,
            },
            text_notif,
          }
        }
      }
    }
  }


  box:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(box)
  end)))

  return box
end
