local wibox       = require("wibox")
local awful       = require("awful")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")

local themeButton = function(icon, name)
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
    forced_width = 90,
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

local serenity    = themeButton("󰖝", "Serenity")
local everforest  = themeButton("󰐅", "Everforest")
local gruvbox     = themeButton("󰌪", "Cat")
local decay       = themeButton("󰃤", "Pop")

local finalwidget = wibox.widget {
  {
    {
      {
        font = beautiful.font .. " 11",
        markup = helpers.colorizeText('Themeing', beautiful.fg3),
        valign = "center",
        widget = wibox.widget.textbox,
      },
      {
        serenity,
        decay,
        gruvbox,
        everforest,
        layout = wibox.layout.fixed.horizontal,
        spacing = 22,
      },
      spacing = 15,
      layout = wibox.layout.fixed.vertical
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
