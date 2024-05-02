local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")

return wibox.widget {
  {
    {
      {
        {
          {
            {
              widget = wibox.widget.textbox,
              font   = beautiful.mono .. " 14",
              markup = helpers.colorizeText(" ~ ", beautiful.bg)
            },
            widget = wibox.container.background,
            bg = beautiful.blue,
          },
          {
            widget = wibox.widget.textbox,
            font   = beautiful.mono .. " 14",
            markup = helpers.colorizeText(" fetch ", beautiful.fg)
          },
          spacing = 10,
          layout = wibox.layout.fixed.horizontal
        },
        {
          {
            forced_height = 150,
            widget = wibox.widget.imagebox,
            image = beautiful.arch,
          },
          {
            {
              markup = "OS: Arch Linux",
              valign = "center",
              font   = beautiful.mono .. " 14",
              widget = wibox.widget.textbox,
            },
            {
              markup = "KR: 6.8.8-arch1-1",
              valign = "center",
              font   = beautiful.mono .. " 14",
              widget = wibox.widget.textbox,
            },
            {
              markup = "WM: awesomewm",
              valign = "center",
              font   = beautiful.mono .. " 14",
              widget = wibox.widget.textbox,
            },
            {
              markup = "SH: bash",
              valign = "center",
              font   = beautiful.mono .. " 14",
              widget = wibox.widget.textbox,
            },
            spacing = 12,
            layout = wibox.layout.fixed.vertical,
          },
          spacing = 40,
          layout = wibox.layout.fixed.horizontal,
        },
        layout = wibox.layout.fixed.vertical,
        spacing = 25,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center",
    },
    widget = wibox.container.margin,
    margins = 30,
  },
  widget = wibox.container.background,
  shape = helpers.rrect(15),
  bg = beautiful.bg
}
