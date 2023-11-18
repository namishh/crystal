local wibox = require("wibox")
local helpers = require("helpers")
local beautiful = require("beautiful")
local awful = require("awful")

local widget = wibox.widget {
  {
    {
      {
        widget = wibox.widget.imagebox,
        image = beautiful.pfp,
        forced_height = 50,
        forced_width = 50,
        align = "center",
        valign = "center",
        clip_shape = helpers.rrect(40),
        resize = true,
      },
      nil,
      {
        {
          {
            {
              font = beautiful.sans .. " 14",
              format = "%a, %d %B",
              align = "center",
              valign = "center",
              widget = wibox.widget.textclock
            },
            widget = wibox.container.margin,
            left = 25,
            right = 25,
          },
          shape = helpers.rrect(50),
          bg = beautiful.mbg,
          widget = wibox.container.background,
        },
        {
          {
            {
              font = beautiful.sans .. " 14",
              id = "uptime",
              markup = helpers.colorizeText("", beautiful.fg),
              valign = "center",
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.margin,
            left = 25,
            right = 25,
          },
          shape = helpers.rrect(50),
          bg = beautiful.mbg,
          widget = wibox.container.background,
        },
        {
          {
            {
              font = beautiful.icon .. " 16",
              markup = helpers.colorizeText("󰅖", beautiful.red),
              valign = "center",
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.margin,
            margins = 20,
          },
          buttons = {
            awful.button({}, 1, function()
              awesome.emit_signal("toggle::exit")
            end)
          },
          shape = helpers.rrect(50),
          bg = beautiful.mbg,
          widget = wibox.container.background,
        },
        spacing = 20,
        layout = wibox.layout.fixed.horizontal,
      },
      layout = wibox.layout.align.horizontal,
    },
    widget = wibox.container.place,
    content_fill_horizontal = true,
    halign = "center",
    valign = "top",
  },
  widget = wibox.container.margin,
  top = 40,
  left = 40,
  right = 40,
}

awesome.connect_signal("signal::uptime", function(v)
  helpers.gc(widget, "uptime").markup = v
end)

return widget
