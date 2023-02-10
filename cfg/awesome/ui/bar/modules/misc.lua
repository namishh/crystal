local M = {}

local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
local app       = require("misc.bling").app_launcher
M.launcher      = wibox.widget {
  {
    {
      buttons = {
        awful.button({}, 1, function()
          app:toggle()
        end)
      },
      font = beautiful.icofont .. " 18",
      markup = " 󰍉 ",
      valign = "center",
      align = "center",
      widget = wibox.widget.textbox,
    },
    bg = beautiful.bg3,
    widget = wibox.container.background
  },
  widget = wibox.container.margin
}

M.powerbutton = wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 16",
        markup = helpers.colorizeText('󰐥', beautiful.err),
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox,
      },
      margins = 8,
      widget = wibox.container.margin
    },
    bg = beautiful.bg3,
    widget = wibox.container.background
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('show::exit')
      --awful.spawn.with_shell('~/.local/bin/rofiscripts/powermenu')
    end)
  },
  widget = wibox.container.margin
}


return M
