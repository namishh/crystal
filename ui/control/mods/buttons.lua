local awful        = require("awful")
local wibox        = require("wibox")
local helpers      = require("helpers")
local beautiful    = require("beautiful")

local createButton = function(cmd, icon, name, labelConnected, labelDisconnected, signal)
  local widget = wibox.widget {
    {
      {
        {
          {
            markup = icon,
            id     = "icon",
            font   = beautiful.icon .. " 18",
            widget = wibox.widget.textbox,
          },
          {
            {
              markup = name,
              id     = "name",
              font   = beautiful.sans .. " 11",
              widget = wibox.widget.textbox,
            },
            {
              markup = labelConnected,
              id     = "label",
              font   = beautiful.sans .. " 10",
              widget = wibox.widget.textbox,
            },
            layout = wibox.layout.fixed.vertical,
            spacing = 0
          },
          layout = wibox.layout.fixed.horizontal,
          spacing = 10
        },
        nil,
        {
          markup = "󰅂",
          font   = beautiful.icon .. " 20",
          id     = "arr",
          widget = wibox.widget.textbox,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      top = 15,
      bottom = 15,
      left = 18,
      right = 18
    },
    widget = wibox.container.background,
    id = "back",
    shape = helpers.rrect(8),
    bg = beautiful.mbg,
    buttons = { awful.button({}, 1, function()
      awful.spawn.with_shell(cmd)
    end) }
  }
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      widget:get_children_by_id("back")[1].bg = beautiful.blue
      widget:get_children_by_id("arr")[1].markup = helpers.colorizeText("󰅂", beautiful.bg)
      widget:get_children_by_id("name")[1].markup = helpers.colorizeText(name, beautiful.bg)
      widget:get_children_by_id("icon")[1].markup = helpers.colorizeText(icon, beautiful.bg)
      widget:get_children_by_id("label")[1].markup = helpers.colorizeText(labelConnected, beautiful.bg)
    else
      widget:get_children_by_id("back")[1].bg = beautiful.mbg .. 'aa'
      widget:get_children_by_id("arr")[1].markup = helpers.colorizeText("󰅂", beautiful.fg .. 'cc')
      widget:get_children_by_id("name")[1].markup = helpers.colorizeText(name, beautiful.fg .. 'cc')
      widget:get_children_by_id("icon")[1].markup = helpers.colorizeText(icon, beautiful.fg .. 'cc')
      widget:get_children_by_id("label")[1].markup = helpers.colorizeText(labelDisconnected, beautiful.fg .. 'cc')
    end
  end)
  return widget
end

local widget       = wibox.widget {
  {
    createButton("~/.config/awesome/misc/scripts/wifi --toggle", "󰤨", "Network", "Connected", "Disconnected",
      "network"),
    createButton("~/.config/awesome/misc/scripts/bluetooth --toggle", "󰂯", "Bluetooth", "Connected", "Disconnected",
      "bluetooth"),
    spacing = 20,
    layout = wibox.layout.flex.horizontal
  },
  {
    createButton("~/.config/awesome/misc/scripts/airplanemode --toggle", "󰀝", "Airplane Mode", "Now In Flight Mode",
      "Turned Off", "airplane"),
    createButton('awesome-client \'naughty = require("naughty") naughty.toggle()\'', "󰍶", "Do Not Disturb",
      "Turned On", "Turned Off", "dnd"),
    spacing = 20,
    layout = wibox.layout.flex.horizontal
  },
  {
    createButton("~/.config/awesome/misc/scripts/redshift --toggle", "󰛨", "Redshift", "Your Eyes Are Safe",
      "Night Light Is Off", "redshift"),
    createButton('pamixer --source 1 -t', "󰍬", "Microphone",
      "Its Muted", "It is turned on", "mic"),
    spacing = 20,
    layout = wibox.layout.flex.horizontal
  },
  layout = wibox.layout.fixed.vertical,
  spacing = 20
}

return widget
