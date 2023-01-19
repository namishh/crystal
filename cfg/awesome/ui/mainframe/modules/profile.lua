local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local profilepicture = wibox.widget {
  {
    image         = beautiful.profilepicture,
    forced_height = 65,
    clip_shape    = gears.shape.circle,
    forced_width  = 65,
    widget        = wibox.widget.imagebox
  },
  widget = wibox.container.background,
  border_width = dpi(2),
  shape = gears.shape.circle,
  border_color = beautiful.pri .. 'cc'
}

local name = wibox.widget {
  nil,
  {
    {
      font = beautiful.font .. " Bold 12",
      markup = "Namish",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    {
      font = beautiful.font .. " 12",
      markup = "@fedorable",
      valign = "center",
      widget = wibox.widget.textbox,
    },
    spacing = 2,
    layout = wibox.layout.align.vertical,
  },
  layout = wibox.layout.align.vertical,
  expand = "none"
}

local power_button = wibox.widget {
  {
    {
      {
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("󰐥", beautiful.fg .. 'cc'),
        font = beautiful.icofont .. " 20",
      },
      widget = wibox.container.margin,
      margins = 10,
    },
    widget = wibox.container.background,
    shape = gears.shape.circle,
    bg = beautiful.bg2 .. 'cc'
  },
  widget = wibox.container.margin,
  buttons = {
    awful.button({}, 1, function()
      awful.spawn.with_shell('loginctl poweroff')
    end)
  },

}

local lock_button = wibox.widget {
  {
    {
      {
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("󰍁", beautiful.fg .. 'cc'),
        font = beautiful.icofont .. " 20",
      },
      widget = wibox.container.margin,
      margins = 10,
    },
    widget = wibox.container.background,
    shape = gears.shape.circle,
    bg = beautiful.bg2 .. 'cc'
  },
  widget = wibox.container.margin,
  buttons = {
    awful.button({}, 1, function()
      awful.spawn.with_shell('~/.local/bin/lock')
    end)
  },

}

local finalwidget = wibox.widget {
  {
    profilepicture,
    name,
    spacing = 20,
    layout = wibox.layout.fixed.horizontal,
  },
  nil,
  {
    lock_button,
    power_button,
    spacing = 20,
    layout = wibox.layout.fixed.horizontal
  },
  layout = wibox.layout.align.horizontal
}

return finalwidget
