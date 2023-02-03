-- the notification themselves
local helpers = require("helpers")
local beautiful = require("beautiful")
local gears = require("gears")
local dpi = beautiful.xresources.apply_dpi
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
return function(icon, notification, width)

  -- table of icons
  local icons = {
    ["firefox"]  = { icon = "󰈹" },
    ["discord"]  = { icon = "󰙯" },
    ["dunstify"] = { icon = "󱝁" },
  }

  local appicon

  if icons[string.lower(notification.app_name)] then
    appicon = icons[string.lower(notification.app_name)]
  else
    appicon = '󱝁'
  end

  local appiconbox = wibox.widget {
    {
      {
        font   = beautiful.icofont .. " 16",
        markup = "<span foreground='" .. beautiful.pri .. "'>" .. appicon .. "</span>",
        align  = "center",
        valign = "center",
        widget = wibox.widget.textbox
      },
      widget = wibox.container.margin,
      margins = 4,
    },
    bg = beautiful.pri .. "1A",
    widget = wibox.container.background,
  }
  local message = wibox.widget {
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {

      markup = helpers.colorizeText(notification.message, beautiful.fg),
      font = beautiful.font .. " 12",
      align = "left",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.scroll.horizontal,

  }
  local title = wibox.widget {
    step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
    speed = 50,
    {
      {
        markup = helpers.colorizeText(notification.title .. "  ", beautiful.fg),
        font = beautiful.font .. " 12",
        align = "left",
        valign = "center",
        widget = wibox.widget.textbox,
      },
      layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.scroll.horizontal,
  }
  local image_width = 70
  local image_height = 70
  if icon == 'none' then
    image_width = 0
    image_height = 0
  end
  local image = wibox.widget {
    {
      image = icon,
      resize = true,
      halign = "center",
      opacity = 0.6,
      valign = "center",
      widget = wibox.widget.imagebox,
    },
    strategy = "exact",
    height = image_height,
    width = image_width,
    widget = wibox.container.constraint,
  }
  local close = wibox.widget {
    markup = helpers.colorizeText("X", beautiful.err),
    font   = beautiful.font .. " 13",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local finalnotif = wibox.widget {
    {
      {
        {
          {
            appiconbox,
            title,
            spacing = 10,
            layout = wibox.layout.fixed.horizontal
          },
          nil,
          close,
          layout = wibox.layout.align.horizontal
        },
        margins = 20,
        widget = wibox.container.margin
      },
      bg = beautiful.bg3,
      widget = wibox.container.background
    },
    {
      {
        {
          image,
          message,
          spacing = 30,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.margin,
        margins = 20,
      },
      bg = beautiful.bg4 .. '66',
      widget = wibox.container.background
    },
    layout = wibox.layout.fixed.vertical,
  }

  close:buttons(gears.table.join(awful.button({}, 1, function()
    _G.notif_center_remove_notif(finalnotif)
  end)))

  return finalnotif
end
