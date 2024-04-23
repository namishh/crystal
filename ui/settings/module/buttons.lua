local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local createButton = function(cmd, image, name, signal)
  local img = gears.color.recolor_image(
    gears.filesystem.get_configuration_dir() .. "theme/icons/settings/" .. image .. ".svg", beautiful.fg)
  local widget = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = img,
            opacity = 0.8,
            forced_height = 27,
            forced_width = 27,
            resize = true,
            id = "image",
          },
          widget = wibox.container.margin,
          margins = 10,
        },
        widget = wibox.container.place,
        halign = "center",
        valign = "center"
      },
      widget = wibox.container.background,
      id = "bg",
      bg = beautiful.bg,
      shape_border_width = 1,
      shape_border_color = beautiful.fg3,
      shape = helpers.rrect(5),
      forced_height = 65,
      buttons = { awful.button({}, 1, function()
        awful.spawn.with_shell(cmd)
      end) }

    },
    {
      markup = helpers.colorizeText(name, beautiful.fg2),
      font = beautiful.sans .. " 12",
      valign = "center",
      align = "center",
      id = "name",
      widget = wibox.widget.textbox,
    },
    layout = wibox.layout.fixed.vertical,
    spacing = 10,
  }
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      helpers.gc(widget, "bg").bg = beautiful.bg3
      helpers.gc(widget, "image").opacity = 1
      helpers.gc(widget, "name").markup = helpers.colorizeText(name, beautiful.fg)
    else
      helpers.gc(widget, "bg").bg = beautiful.bg
      helpers.gc(widget, "image").opacity = 0.6
      helpers.gc(widget, "name").markup = helpers.colorizeText(name, beautiful.comm)
    end
  end)
  return widget
end

local widget = wibox.widget {
  {
    createButton("~/.config/awesome/lib/scripts/wifi.sh --toggle", "wifi", "Network",
      "network"),
    createButton("~/.config/awesome/lib/scripts/bluetooth.sh --toggle", "bluetooth", "Bluetooth",
      "bluetooth"),
    createButton("awesome-client \'naughty = require(\"naughty\") naughty.toggle()\'", "dnd", "Silence",
      "dnd"),
    spacing = 15,
    layout = wibox.layout.flex.horizontal
  },
  widget = wibox.container.margin,
  top = 15,
  left = 15,
  right = 15,
}

return widget
