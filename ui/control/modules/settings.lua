local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local helpers      = require("helpers")
local wifidaemon   = require("daemons.net")

local createButton = function(label, labelfalse, text, signal, cmd, height)
  local settingbuttonlabel = wibox.widget {
    align = 'center',
    font = beautiful.icofont .. " 14",
    markup = label,
    widget = wibox.widget.textbox,
  }

  local settingbuttontext = wibox.widget {
    align = 'start',
    font = beautiful.font .. " Bold 11",
    markup = text,
    widget = wibox.widget.textbox,
  }

  local settingbuttonstat = wibox.widget {
    align = 'start',
    font = beautiful.font .. " 10",
    markup = "On",
    widget = wibox.widget.textbox,
  }

  local settingbuttonback = wibox.widget {
    {
      {
        settingbuttonlabel,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 11
    },
    shape = helpers.rrect(40),
    widget = wibox.container.background,
    bg = beautiful.pri .. '11',
  }

  local settingbuttonwidget = wibox.widget {
    {
      {
        {
          settingbuttonback,
          widget = wibox.container.place,
          valign = 'center',
        },
        {
          {
            settingbuttontext,
            settingbuttonstat,
            spacing = 3,
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.place,
          valign = 'center',
        },
        spacing = 15,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      margins = 15
    },
    forced_height = height,
    forced_width = 200,
    widget = wibox.container.background,
    bg = beautiful.fg3 .. '22'
  }


  settingbuttonwidget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell(cmd)
  end))
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      settingbuttonlabel.markup = helpers.colorizeText(label, beautiful.bg)
      settingbuttonback.bg = beautiful.pri
      settingbuttonstat.markup = 'On'
    else
      settingbuttonlabel.markup = helpers.colorizeText(labelfalse, beautiful.fg .. 'cc')
      settingbuttonstat.markup = 'Off'
      settingbuttonback.bg = beautiful.pri .. '11'
    end
  end)

  return settingbuttonwidget
end
awesome.connect_signal("settings::wifi", function()
  wifidaemon:toggleWireless()
end)
local wifibtn     = createButton("󰤨", "󰤮", 'Network', 'network',
  "awesome-client 'awesome.emit_signal(\"settings::wifi\")'", 70)
local bluetooth   = createButton("󰂯", "󰂲", 'Bluetooth', 'bluetooth',
  "~/.config/awesome/ui/control/scripts/bluetooth --toggle", 70)
local dnd         = createButton("󰍶", "󱑙", 'Silence', 'dnd',
  'awesome-client \'naughty = require("naughty") naughty.toggle()\'', 100)
local airplane    = createButton("󰀝", "󰀞", 'Airplane', 'airplane',
  "~/.config/awesome/ui/control/scripts/airplanemode --toggle", 70)

local boreButton  = function(icon, signal, cmd)
  local borebuttonwidget = wibox.widget {
    {
      {
        {
          id = "icon",
          align = 'center',
          font = beautiful.icofont .. " 22",
          markup = icon,
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.place,
        valign = 'center',
      },
      widget = wibox.container.margin,
      margins = 30
    },
    shape = helpers.rrect(4),
    widget = wibox.container.background,
    bg = beautiful.fg3 .. '22'
  }

  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      borebuttonwidget:get_children_by_id('icon')[1].markup = helpers.colorizeText(icon, beautiful.bg)
      borebuttonwidget.bg = beautiful.pri
    else
      borebuttonwidget:get_children_by_id('icon')[1].markup = helpers.colorizeText(icon, beautiful.fg)
      borebuttonwidget.bg = beautiful.fg3 .. '22'
    end
  end)

  borebuttonwidget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell(cmd)
  end))
  return borebuttonwidget
end

local picom       = boreButton('󰗘', 'picom', '~/.config/awesome/scripts/ui/control/picom --toggle')
local mic         = boreButton('󰍭', 'mic', 'pamixer --default-source -t')

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
        {
          wifibtn,
          bluetooth,
          airplane,
          layout = wibox.layout.fixed.vertical,
        },
        {
          dnd,
          {
            picom,
            mic,
            layout = wibox.layout.fixed.horizontal,
            spacing = 16,
          },
          layout = wibox.layout.fixed.vertical,
          spacing = 16,
        },
        spacing = 20,
        layout = wibox.layout.fixed.horizontal
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
