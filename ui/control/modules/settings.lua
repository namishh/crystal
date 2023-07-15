local wibox        = require("wibox")
local awful        = require("awful")
local beautiful    = require("beautiful")
local dpi          = require("beautiful").xresources.apply_dpi
local helpers      = require("helpers")
local wifidaemon   = require("daemons.net")

local createButton = function(label, labelfalse, text, signal, cmd, height)
  local settingbuttonlabel = wibox.widget {
    align = 'center',
    font = beautiful.icofont .. " 16",
    markup = label,
    widget = wibox.widget.textbox,
  }

  local settingbuttonback = wibox.widget {
    {
      {
        settingbuttonlabel,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.margin,
      margins = 18
    },
    shape = helpers.rrect(40),
    widget = wibox.container.background,
    bg = beautiful.pri .. '11',
  }

  local settingbuttonwidget = wibox.widget {
    {
      {
        settingbuttonback,
        widget = wibox.container.place,
        valign = 'center',
      },
      widget = wibox.container.margin,
      margins = 10
    },
    widget = wibox.container.background,
  }


  settingbuttonwidget:add_button(awful.button({}, 1, function()
    awful.spawn.with_shell(cmd)
  end))
  awesome.connect_signal('signal::' .. signal, function(status)
    if status then
      settingbuttonlabel.markup = helpers.colorizeText(label, beautiful.bg)
      settingbuttonback.bg = beautiful.pri
    else
      settingbuttonlabel.markup = helpers.colorizeText(labelfalse, beautiful.fg .. 'cc')
      settingbuttonback.bg = beautiful.pri .. '11'
    end
  end)

  return settingbuttonwidget
end
awesome.connect_signal("settings::wifi", function()
  wifidaemon:toggleWireless()
end)
local wifibtn     = createButton("󰤨", "󰤮", 'Network', 'network',
  "awesome-client 'awesome.emit_signal(\"settings::wifi\")'", 120)
local bluetooth   = createButton("󰂯", "󰂲", 'Bluetooth', 'bluetooth',
  "~/.config/awesome/ui/control/scripts/bluetooth --toggle", 120)
local dnd         = createButton("󰍶", "󱑙", 'Silence', 'dnd',
  'awesome-client \'naughty = require("naughty") naughty.toggle()\'', 120)
local airplane    = createButton("󰀝", "󰀞", 'Airplane', 'airplane',
  "~/.config/awesome/ui/control/scripts/airplanemode --toggle", 120)
local picom       = createButton('󰗘', '󰗘', "Picom", 'picom', '~/.config/awesome/scripts/ui/control/picom --toggle',
  120)
local mic         = createButton('󰍭', '󰍭', "Mic", 'mic', 'pamixer --default-source -t', 120)

local finalwidget = {
  {
    {
      {
        {
          wifibtn,
          bluetooth,
          layout = wibox.layout.fixed.vertical,
        },
        {
          dnd,
          airplane,
          layout = wibox.layout.fixed.vertical,
        },
        {
          mic,
          picom,
          layout = wibox.layout.fixed.vertical,
        },
        spacing = 6,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.margin,
      margins = {
        top = 10,
        bottom = 10,
        left = 8,
        right = 8
      },
    },
    widget = wibox.container.background,
    bg = beautiful.bg2 .. 'cc',
  },
  {
    {
      resize = true,
      forced_width = 180,
      shape = helpers.rrect(3),
      widget = wibox.widget.imagebox,
      horizontal_fit_policy = "fit",
      vertical_fit_policy = "fit",
      image = beautiful.profilepicture,
    },
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 135, 0 },
        stops = { { 0, beautiful.bg .. "d1" }, { 1, beautiful.bg .. 'e1' } }
      },
      widget = wibox.container.background,
    },
    widget = wibox.layout.stack
  },
  spacing = 16,
  layout = wibox.layout.fixed.horizontal
}


return finalwidget
