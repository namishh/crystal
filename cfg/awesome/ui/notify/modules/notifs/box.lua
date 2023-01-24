local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local helpers   = require("helpers")

local empty = require("ui.notify.modules.notifs.empty")

local clearButton = wibox.widget {
  {
    {
      font = beautiful.font .. " 11",
      markup = helpers.colorizeText("Clear All", beautiful.pri),
      widget = wibox.widget.textbox,
      valign = "center",
      align = "center",
    },
    margins = dpi(6),
    widget = wibox.container.margin
  },
  bg = beautiful.pri .. '11',
  widget = wibox.container.background,

}

local header = wibox.widget {
  {
    font = beautiful.font .. " 14",
    markup = "Notifications (0)",
    widget = wibox.widget.textbox,
    valign = "center",
    align = "center"
  },
  nil,
  clearButton,
  layout = wibox.layout.align.horizontal,
}

local finalwidget = wibox.widget {
  {
    {
      header,
      empty,
      spacing = dpi(10),
      layout = wibox.layout.fixed.vertical,
    },
    margins = dpi(10),
    widget = wibox.container.margin
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background,
}

return finalwidget
