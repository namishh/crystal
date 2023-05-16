local M         = {}
local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local helpers   = require("helpers")
M.launcher      = wibox.widget {
  {
    {
      {
        font = beautiful.font .. " 16",
        markup = helpers.colorizeText(" ", beautiful.pri),
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox,
      },
      margins = 6,
      widget = wibox.container.margin
    },
    bg = beautiful.bg2,
    widget = wibox.container.background
  },
  -- {
  --   image         = beautiful.profilepicture,
  --   clip_shape    = helpers.rrect(100),
  --   forced_height = 35,
  --   forced_width  = 35,
  --   halign        = 'center',
  --   valign        = 'center',
  --   widget        = wibox.widget.imagebox
  -- },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal("toggle::dashboard")
    end)
  },
  widget = wibox.container.margin
}

M.powerbutton   = wibox.widget {
  {
    {
      {
        font = beautiful.icofont .. " 16",
        markup = helpers.colorizeText('󰐥', beautiful.err),
        valign = "center",
        align = "center",
        widget = wibox.widget.textbox,
      },
      margins = 6,
      widget = wibox.container.margin
    },
    bg = beautiful.bg2,
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
