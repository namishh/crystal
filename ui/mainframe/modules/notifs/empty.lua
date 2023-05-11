local awful = require("awful")
local beautiful = require("beautiful")
local dpi = beautiful.xresources.apply_dpi
local helpers = require("helpers")
local wibox = require("wibox")

return wibox.widget {
  {
    {
      {
        image = beautiful.nonotif,
        resize = true,
        forced_height = 120,
        halign = "center",
        valign = "center",
        widget = wibox.widget.imagebox,
      },
      {
        widget = wibox.widget.textbox,
        markup = helpers.colorizeText("You are completely caught up :)", beautiful.fg .. "4D"),
        font = beautiful.font .. " 14",
        valign = "center",
        align = "center"
      },
      spacing = 20,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.place,
    valign = 'center'
  },
  forced_height = 500,
  margins = { top = dpi(15) },
  widget = wibox.container.margin

}
