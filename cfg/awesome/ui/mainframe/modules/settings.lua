local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local gears        = require("gears")
local helpers      = require("helpers")
local naughty      = require("naughty")
local createButton = function(label, labelfalse, text, signal)

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
        settingbuttontext,
        layout = wibox.layout.fixed.vertical,
        spacing = dpi(15)
      },
      forced_width = dpi(115),
      forced_height = dpi(115),
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

  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      settingbuttonlabel.markup = helpers.colorizeText(label, beautiful.pri)
      settingbuttonback.bg = beautiful.pri .. '11'
    else
      settingbuttonlabel.markup = labelfalse
      settingbuttonback.bg = beautiful.bg4 .. 'aa'
    end
  end)

  return settingbuttonwidget
end

local wifibtn = createButton("󰤨", "󰤮", 'Wifi', 'network')
local bluetooth = createButton("󰂯", "󰂲", 'Bluetooth', 'bluetooth')
local dnd = createButton("󰍶", "󱑙", 'Silence', 'dnd')
local airplane = createButton("󰀝", "󰀞", 'Airplane', 'airplane')
local picom = createButton("󱂬", "󱂬", 'Picom', 'picom')
local mic = createButton("󰍭", "󰍬", 'Microphone', 'mic')

wifibtn:add_button(awful.button({}, 1, function()
  awful.spawn.with_shell('~/.config/awesome/scripts/wifi --toggle')
end))

bluetooth:add_button(awful.button({}, 1, function()
  awful.spawn.with_shell('~/.config/awesome/scripts/bluetooth --toggle')
end))


airplane:add_button(awful.button({}, 1, function()
  awful.spawn.with_shell('~/.config/awesome/scripts/airplane --toggle')
end))

dnd:add_button(awful.button({}, 1, function()
  naughty.toggle()
end))

picom:add_button(awful.button({}, 1, function()
  awful.spawn.with_shell('~/.config/awesome/scripts/picom --toggle')
end))

mic:add_button(awful.button({}, 1, function()
  awful.spawn.with_shell('pamixer --source 1 -t')
end))
local hidden = wibox.widget {
  {
    picom,
    dnd,
    mic,
    layout = wibox.layout.fixed.horizontal,
    spacing = 12,
  },
  widget = wibox.container.margin,
  visible = false,
  margins = {
    top = dpi(20),
  }
}

local finalwidget = {
  {
    {
      {
        wifibtn,
        bluetooth,
        -- dnd,
        airplane,
        layout = wibox.layout.fixed.horizontal,
        spacing = 12,
      },
      hidden,
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
awesome.connect_signal("signal::toggler", function(value)
  hidden.visible = value
end)



return finalwidget
