local awful = require "awful"
local gears = require "gears"
local wibox = require "wibox"
local beautiful = require "beautiful"
local helpers = require "helpers"
local getIcon = require "mods.getIcon"
local dpi = beautiful.xresources.apply_dpi

----- Titlebar
local get_titlebar = function(c)
  -- Button
  local buttons = gears.table.join({
    awful.button({}, 1, function()
      c:activate { context = "titlebar", action = "mouse_move" }
    end),
    awful.button({}, 3, function()
      c:activate { context = "titlebar", action = "mouse_resize" }
    end)
  })

  -- Titlebar's decorations
  local left = wibox.widget {
    {
      {
        awful.titlebar.widget.closebutton(c),
        awful.titlebar.widget.maximizedbutton(c),
        awful.titlebar.widget.minimizebutton(c),
        spacing = dpi(5),
        layout = wibox.layout.fixed.horizontal,
      },
      widget = wibox.container.margin,
      margins = 8
    },
    shape = helpers.rrect(5),
    widget = wibox.container.background,
    bg = beautiful.mbg
  }

  local middle = wibox.widget {
    buttons = buttons,
    layout = wibox.layout.fixed.horizontal,
  }

  local right = wibox.widget {
    {
      {
        {
          widget = wibox.widget.imagebox,
          image = getIcon(c, c.class, c.class),
          forced_width = 30,
          clip_shape = helpers.rrect(100),
          resize = true,
        },
        widget = wibox.container.place,
        halign = "center",
      },
      margins = dpi(5),
      widget = wibox.container.margin
    },
    bg = beautiful.mbg,
    shape = helpers.rrect(5),
    widget = wibox.container.background
  }

  local container = wibox.widget {
    bg = beautiful.bar,
    shape = function(cr, w, h) gears.shape.partially_rounded_rect(cr, w, h, true, true, false, false, 0) end,
    widget = wibox.container.background,
  }

  c:connect_signal("focus", function() container.bg = beautiful.bg end)
  c:connect_signal("unfocus", function() container.bg = beautiful.bg end)

  return wibox.widget {
    {
      {
        left,
        middle,
        right,
        layout = wibox.layout.align.horizontal,
      },
      margins = { top = dpi(5), bottom = dpi(5), left = dpi(5), right = dpi(5) },
      widget = wibox.container.margin,
    },
    widget = container,
  }
end

local function top(c)
  local titlebar = awful.titlebar(c, {
    position = 'top',
    size = dpi(50),
    bg = beautiful.transparent
  })

  titlebar:setup {
    widget = get_titlebar(c)
  }
end

client.connect_signal("request::titlebars", function(c)
  top(c)
end)
