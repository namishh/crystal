local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local helpers      = require("helpers")
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
      margins = 15
    },
    shape = helpers.rrect(40),
    widget = wibox.container.background,
    bg = beautiful.bg4 .. 'aa',
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
      settingbuttonback.bg = beautiful.bg4 .. 'aa'
    end
  end)

  return settingbuttonwidget
end

local wifibtn      = createButton("󰤨", "󰤮", 'Network', 'network', "~/.config/awesome/scripts/wifi --toggle", 90)
local bluetooth    = createButton("󰂯", "󰂲", 'Bluetooth', 'bluetooth',
  "~/.config/awesome/scripts/bluetooth --toggle", 90)
local dnd          = createButton("󰍶", "󱑙", 'Silence', 'dnd',
  'awesome-client \'naughty = require("naughty") naughty.toggle()\'', 100)
local airplane     = createButton("󰀝", "󰀞", 'Airplane', 'airplane',
  "~/.config/awesome/scripts/airplanemode --toggle", 90)

local themeButton  = function(icon, name)
  local themeButtonLabel = wibox.widget {
    align = 'center',
    font = beautiful.icofont .. " 14",
    markup = icon,
    widget = wibox.widget.textbox,
  }

  local themeButtonText = wibox.widget {
    align = 'center',
    font = beautiful.font .. " Bold 11",
    markup = name,
    widget = wibox.widget.textbox,
  }
  local widget = wibox.widget {
    {
      {
        themeButtonLabel,
        themeButtonText,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      align = 'center'
    },
    forced_width = 100,
    forced_height = 69,
    shape = helpers.rrect(3),
    widget = wibox.container.background,
    bg = beautiful.fg3 .. '33'
  }
  widget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell('notify-send "Changing theme to ' .. name .. '" "This might take some time!"')
    awful.spawn.with_shell('setTheme ' .. string.lower(name))
  end))
  awesome.connect_signal("signal::theme", function(val)
    if val == string.lower(name) then
      widget.bg = beautiful.pri
      themeButtonLabel.markup = helpers.colorizeText(icon, beautiful.bg)
      themeButtonText.markup = helpers.colorizeText(name, beautiful.bg)
    end
  end)
  return widget
end

local serenity     = themeButton("󰖝", "Serenity")
local everforest   = themeButton("󰐅", "Everforest")
local gruvbox      = themeButton("󰌪", "Pop")
local decay        = themeButton("󰃤", "Decay")

local finalwidget  = {
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
            serenity,
            decay,
            layout = wibox.layout.fixed.horizontal,
            spacing = 16,
          },
          {
            gruvbox,
            everforest,
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
