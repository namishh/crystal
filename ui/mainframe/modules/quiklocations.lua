local helpers = require("helpers")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local createLink = function(n, l)
  return wibox.widget {
    {
      id = "icon",
      font = beautiful.font .. " 14",
      markup = helpers.colorizeText("~/", beautiful.pri) .. n,
      valign = "center",
      align = "start",
      widget = wibox.widget.textbox,
    },
    widget = wibox.container.margin,
    margins = 3,
    buttons = {
      awful.button({}, 1, function()
        awful.spawn.with_shell("nemo " .. l)
      end)
    },
  }
end

local finalWidget = wibox.widget {
  {
    {
      {
        createLink("Desktop", "~/Desktop"),
        createLink("Documenuts", "~/Documents"),
        createLink("Pictures", "~/Pictures"),
        createLink("V/Recordings", "~/Videos/Recordings"),
        spacing = 12,
        layout = wibox.layout.fixed.vertical
      },
      {
        createLink("D/Homwork", "~/Desktop/Homework"),
        createLink("P/Scrots", "~/Pictures/Screenshots"),
        createLink(".c/awesome", "~/.config/awesome"),
        createLink(".c/nvim", "~/.config/nvim"),
        spacing = 12,
        layout = wibox.layout.fixed.vertical
      },
      spacing = 25,
      layout = wibox.layout.fixed.horizontal,
    },
    widget = wibox.container.margin,
    margins = 12,
  },
  shape = helpers.rrect(8),
  widget = wibox.container.background,
  bg = beautiful.mbg
}

return finalWidget
