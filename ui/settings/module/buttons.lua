local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local createButton = function(cmd, image, name, signal, r)
  local img = gears.color.recolor_image(
    gears.filesystem.get_configuration_dir() .. "theme/icons/settings/" .. image .. ".svg", beautiful.fg)
  local widget = wibox.widget {
    {
      {
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
          shape = helpers.rrect(100),
          bg = beautiful.bg,
          forced_height = 74,
          forced_width = 75,
          buttons = { awful.button({}, 1, function()
            awful.spawn.with_shell(cmd)
          end) }
        },
        layout = wibox.layout.fixed.vertical,
        spacing = 10,
      },
      widget = wibox.container.margin,
      margins = 8,
    },
    shape = helpers.prect(r == 1 and true or false, r == 2 and true or false, r == 2 and true or false, r == 1 and true or false, 100),
    widget = wibox.container.background,
    bg = beautiful.mab,

  }
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      helpers.gc(widget, "bg").bg = beautiful.magenta .. '22'
      helpers.gc(widget, "image").opacity = 1
    else
      helpers.gc(widget, "bg").bg = beautiful.mab
      helpers.gc(widget, "image").opacity = 0.6
    end
  end)
  return widget
end

local widget = wibox.widget {
  {
    {
      {
        createButton("~/.config/awesome/lib/scripts/wifi.sh --toggle", "wifi", "Network",
          "network", 1),
        createButton("~/.config/awesome/lib/scripts/redshift.sh --toggle", "redshift", "Night Light",
          "redshift", 0),
        createButton("~/.config/awesome/lib/scripts/bluetooth.sh --toggle", "bluetooth", "Bluetooth",
          "bluetooth", 0),
        createButton("awesome-client \'naughty = require(\"naughty\") naughty.toggle()\'", "dnd", "Silence",
          "dnd", 0),
        createButton("pamixer --source 314 -t", "mic", "Silence",
          "mic", 2),
        spacing = 0,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      top = 15,
      left = 15,
      right = 15,
      bottom = 15,
    },
    widget = wibox.container.background,
    bg = beautiful.blue .. '11',
    shape = helpers.rrect(10),
  },
  widget = wibox.container.margin,
  top = 15,
  left = 15,
  right = 15,
}

return widget
