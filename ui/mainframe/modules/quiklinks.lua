local helpers = require("helpers")
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")

local createButton = function(icon, name, color)
  return wibox.widget {
    {
      {
        {
          id = "icon",
          font = beautiful.icofont .. " 35",
          markup = helpers.colorizeText(icon, color),
          valign = "center",
          align = "center",
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.margin,
        margins = 12,
      },
      shape = helpers.rrect(8),
      bg = beautiful.fg3 .. '33',
      widget = wibox.container.background,
      buttons = {
        awful.button({}, 1, function()
          awful.spawn.with_shell("firefox " .. name)
        end)
      },
    },
    widget = wibox.container.place,
    halign = 'center',
  }
end

local finalwidget = wibox.widget {
  {
    {
      createButton("󰑍", 'https://www.reddit.com/', beautiful.err),
      createButton("󰠖", 'https://www.4chan.org/', beautiful.ok),
      createButton("󰓌", 'https://stackoverflow.com/', beautiful.warn),
      createButton("󰊤", 'https://github.com/', beautiful.fg),
      createButton("󰗃", "https://youtube.com/", beautiful.pri),
      spacing = 18,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    top = 18,
    bottom = 18
  },
  forced_width = 100,
  shape = helpers.rrect(8),
  widget = wibox.container.background,
  bg = beautiful.mbg
}

return finalwidget
