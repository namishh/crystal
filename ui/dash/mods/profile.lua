local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget {
  {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            image = beautiful.pfp,
            forced_height = 140,
            forced_width = 140,
            clip_shape = helpers.rrect(100),
            resize = true,
          },
          widget = wibox.container.place,
          halign = "center"
        },
        {
          markup = helpers.colorizeText("Welcome, " .. beautiful.user .. "!", beautiful.fg),
          align  = 'center',
          font   = beautiful.sans .. " 18",
          widget = wibox.widget.textbox
        },
        {
          id     = "uptime",
          markup = helpers.colorizeText("Running since ", beautiful.fg),
          align  = 'center',
          font   = beautiful.sans .. " 14",
          widget = wibox.widget.textbox
        },
        spacing = 10,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      margins = 30,
    },
    shape = helpers.rrect(20),
    widget = wibox.container.background,
    bg = beautiful.mbg,
  },
  widget = wibox.container.margin,
  bottom = 20
}
awesome.connect_signal("signal::uptime", function(v)
  helpers.gc(widget, "uptime").markup = helpers.colorizeText(v, beautiful.fg2 .. "99")
end)


return widget
