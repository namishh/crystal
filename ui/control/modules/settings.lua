local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local helpers      = require("helpers")
local createButton = function(label, labelfalse, text, signal, cmd)

  local settingbuttonlabel = wibox.widget {
    align = 'center',
    font = beautiful.icofont .. " 20",
    markup = label,
    widget = wibox.widget.textbox,
  }

  local settingbuttontext = wibox.widget {
    align = 'center',
    font = beautiful.font .. " 11",
    markup = text,
    widget = wibox.widget.textbox,
  }

  local settingbuttonback = wibox.widget {
    {
      nil,
      {
        settingbuttonlabel,
        layout = wibox.layout.fixed.vertical,
      },
      forced_width = dpi(78),
      forced_height = dpi(78),
      expand = "none",
      layout = wibox.layout.align.vertical,
    },
    widget = wibox.container.background,
    bg = beautiful.bg4 .. 'aa',
    shape = helpers.rrect(3)
  }

  local settingbuttonwidget = wibox.widget {
    settingbuttonback,
    widget = wibox.container.margin,
    margins = {
      left = dpi(10),
      right = dpi(10)
    }
  }

  settingbuttonwidget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell(cmd)
  end))
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      settingbuttonlabel.markup = helpers.colorizeText(label, beautiful.pri)
      -- settingbuttontext.markup = helpers.colorizeText(text, beautiful.bg)
      --settingbuttonback.bg = "#a2b5c7"
      settingbuttonback.bg = beautiful.pri .. '15'
      settingbuttonback.fg = beautiful.pri
    else
      settingbuttonlabel.markup = helpers.colorizeText(labelfalse, beautiful.fg .. 'cc')
      -- settingbuttontext.markup = helpers.colorizeText(text, beautiful.fg .. 'cc')
      settingbuttonback.bg = beautiful.bg4 .. 'aa'
    end
  end)

  return settingbuttonwidget
end

local wifibtn = createButton("󰤨", "󰤮", 'Wifi', 'network', "~/.config/awesome/scripts/wifi --toggle")
local bluetooth = createButton("󰂯", "󰂲", 'Bluetooth', 'bluetooth', "~/.config/awesome/scripts/bluetooth --toggle")
local dnd = createButton("󰍶", "󱑙", 'Silence', 'dnd',
  'awesome-client \'naughty = require("naughty") naughty.toggle()\'')
local airplane = createButton("󰀝", "󰀞", 'Airplane', 'airplane', "~/.config/awesome/scripts/airplanemode --toggle")


local finalwidget = {
  {
    {
      {
        font = beautiful.font .. " 11",
        markup = helpers.colorizeText('Quick Actions', beautiful.fg3),
        valign = "center",
        widget = wibox.widget.textbox,
      },
      {
        wifibtn,
        bluetooth,
        airplane,
        dnd,
        layout = wibox.layout.fixed.horizontal,
        spacing = 12,
      },
      spacing = 16,
      layout = wibox.layout.fixed.vertical,
      widget = wibox.container.margin
    },
    widget = wibox.container.margin,
    margins = {
      left = 12,
      right = 12,
      top = 15,
      bottom = 16,
    }
  },
  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc',
}


return finalwidget
