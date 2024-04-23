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
            bg = beautiful.fg
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
          image = beautiful.arch,
          forced_height = 180,
          forced_width = 180,
          resize = true,
        },
        {
          {
            font = beautiful.mono .. " 14",
            markup = helpers.colorizeText('OS  : Arch', beautiful.fg),
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
      spacing = 20,
      layout = wibox.layout.fixed.vertical,
    },
    widget = wibox.container.margin,
    margins = 40
  },
  widget = wibox.container.background,
  bg = beautiful.bg,
  forced_width = 460,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5)
}

return widget
