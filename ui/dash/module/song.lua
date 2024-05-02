local playerctl = require("mods.playerctl").lib()
local beautiful = require("beautiful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")

local widget = wibox.widget {
  {
    {
      id            = "image",
      image         = beautiful.pfp,
      clip_shape    = helpers.rrect(15),
      forced_height = 265,
      opacity       = 0.2,
      forced_width  = 265,
      widget        = wibox.widget.imagebox
    },
    {
      {
        {
          {
            id           = "song",
            forced_width = 235,
            font         = beautiful.sans .. ' Bold 16',
            widget       = wibox.widget.textbox,
          },
          {
            id = "artist",
            forced_width = 235,
            font = beautiful.sans .. ' 14',
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.fixed.vertical,
          spacing = 5,
        },
        widget = wibox.container.place,
        valign = "bottom",
        halign = "left",
      },
      widget = wibox.container.margin,
      margins = 20,
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.background,
  shape  = helpers.rrect(15),
  bg     = beautiful.scheme == "serenity" and beautiful.bg or beautiful.fg
}

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  helpers.gc(widget, 'image'):set_image(helpers.cropSurface(1.04, gears.surface.load_uncached(album_path)))
  helpers.gc(widget, 'song'):set_markup_silently(helpers.colorizeText(title or "NO",
    beautiful.scheme == "serenity" and beautiful.fg or beautiful.bg))
  helpers.gc(widget, 'artist'):set_markup_silently(helpers.colorizeText(artist or "NO",
    beautiful.scheme == "serenity" and beautiful.fg or beautiful.bg))
end)
return widget
