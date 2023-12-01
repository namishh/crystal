local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require("helpers")


local widget = wibox.widget {
  {
    {
      {
        {
          {
            {
              {
                font = beautiful.mono .. " 14",
                markup = helpers.colorizeText('>', beautiful.bg),
                widget = wibox.widget.textbox,
              },
              widget = wibox.container.margin,
              top = 5,
              bottom = 5,
              left = 10,
              right = 10,
            },
            widget = wibox.container.background,
            bg = beautiful.blue
          },
          {
            {
              font = beautiful.mono .. " 14",
              markup = helpers.colorizeText('fetch.sh', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.place,
            valign = "center",
          },
          spacing = 15,
          layout = wibox.layout.fixed.horizontal,
        },
        nil,
        nil,
        layout = wibox.layout.align.horizontal,
      },
      {
        {
          widget = wibox.widget.imagebox,
          image = beautiful.nixos,
          forced_height = 140,
          forced_width = 140,
          resize = true,
        },
        {
          {
            font = beautiful.mono .. " 14",
            markup = helpers.colorizeText('OS  : NixOS 24.05', beautiful.fg),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono .. " 14",
            markup = helpers.colorizeText('WM  : Awesome', beautiful.fg),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono .. " 14",
            markup = helpers.colorizeText('USER: ' .. beautiful.user, beautiful.fg),
            widget = wibox.widget.textbox,
          },
          {
            font = beautiful.mono .. " 14",
            markup = helpers.colorizeText('SH  : ZSH', beautiful.fg),
            widget = wibox.widget.textbox,
          },
          spacing = 8,
          layout = wibox.layout.fixed.vertical,
        },
        spacing = 20,
        layout = wibox.layout.fixed.horizontal,
      },
      {
        {
          {
            widget = wibox.container.background,
            bg = beautiful.bg3,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.red,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.green,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.yellow,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.blue,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          {
            widget = wibox.container.background,
            bg = beautiful.magenta,
            forced_height = 20,
            shape = helpers.rrect(5),
            forced_width = 20,
          },
          spacing = 12,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.place,
        halign = "center"
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 40
  },
  widget = wibox.container.background,
  bg = beautiful.mbg,
  shape = helpers.rrect(20)
}

return widget
