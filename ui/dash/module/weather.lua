local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require "beautiful"
local gears     = require("gears")
local helpers   = require "helpers"

local widget    = wibox.widget {
  {
    {
      id = "image",
      forced_height = 180,
      forced_width = 460,
      image = helpers.cropSurface(1.53, gears.surface.load_uncached(beautiful.songdefpicture)),
      widget = wibox.widget.imagebox,
      clip_shape = helpers.rrect(5),
      opacity = 0.9,
      resize = true,
      horizontal_fit_policy = "fit"
    },
    {
      {
        widget = wibox.widget.textbox,
      },
      bg = {
        type = "linear",
        from = { 0, 0 },
        to = { 460, 0 },
        stops = { { 0, beautiful.bg .. "ff" }, { 1, beautiful.bg .. 'cc' } }
      },
      shape = helpers.rrect(5),
      widget = wibox.container.background,
    },
    {
      {
        {
          {
            id = "temp",
            font = beautiful.sans .. " 32",
            markup = "31 C",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          {
            id = "fl",
            font = beautiful.sans .. " 12",
            markup = "Feels Like 30 C",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          {
            id = "humid",
            font = beautiful.sans .. " 12",
            markup = "Humidity: 30%",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          spacing = 5,
          layout = wibox.layout.fixed.vertical,
        },
        nil,
        {

          {
            font = beautiful.sans .. " 18",
            markup = "New Delhi",
            valign = "center",
            align = "right",
            widget = wibox.widget.textbox,
          },
          {
            id = "desc",
            font = beautiful.sans .. " 12",
            markup = helpers.colorizeText("Scattered Clouds", beautiful.comm),
            valign = "center",
            align = "right",
            widget = wibox.widget.textbox,
          },
          spacing = 5,
          layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      margins = {
        left = 30,
        right = 30,
        top = 20,
        bottom = 20,
      },
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.background,
  bg = beautiful.mbg,
  shape_border_width = 1,
  shape_border_color = beautiful.fg3,
  shape = helpers.rrect(5),
}

awesome.connect_signal("signal::weather", function(out)
  helpers.gc(widget, "image").image = helpers.cropSurface(1.53, gears.surface.load_uncached(out.thumb))
  helpers.gc(widget, "temp").markup = out.temp .. "°C"
  helpers.gc(widget, "desc").markup = helpers.colorizeText(out.desc, beautiful.comm)
  helpers.gc(widget, "humid").markup = helpers.colorizeText("Humidity: " .. out.humidity .. "%", beautiful.comm)
  helpers.gc(widget, "fl").markup = helpers.colorizeText("Feels Like " .. out.temp .. "°C", beautiful.comm)
end)

return widget
