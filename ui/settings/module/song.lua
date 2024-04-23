local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local pctl      = require("mods.playerctl")
local helpers   = require("helpers")

local playerctl = pctl.lib()

local art       = wibox.widget {
  image = helpers.cropSurface(2.05, gears.surface.load_uncached(beautiful.songdefpicture)),
  opacity = 0.3,
  resize = true,
  forced_height = 190,
  forced_width = 400,
  clip_shape = helpers.rrect(5),
  widget = wibox.widget.imagebox
}

local widget    = wibox.widget {
  {
    {
      art,
      {
        {
          widget = wibox.widget.textbox,
        },
        bg = {
          type = "linear",
          from = { 0, 0 },
          to = { 200, 0 },
          stops = { { 0, beautiful.bg .. "ff" }, { 1, beautiful.bg .. 'aa' } }
        },
        shape = helpers.rrect(5),
        widget = wibox.container.background,
      },
      {
        {
          {
            {
              font = beautiful.sans .. " 10",
              markup = helpers.colorizeText('Now Playing', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            {
              id = "songname",
              font = beautiful.sans .. " SemiBold 14",
              markup = helpers.colorizeText('Song Name', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            {
              id = "artist",
              font = beautiful.sans .. " 12",
              markup = helpers.colorizeText('Artist Name', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            spacing = 4,
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.place,
          halign = "left",
          valign = "top"
        },
        widget = wibox.container.margin,
        margins = 15,
      },
      layout = wibox.layout.stack,
    },
    widget = wibox.container.background,
    id = "bg",
    bg = beautiful.bg,
    shape_border_width = 1,
    shape_border_color = beautiful.fg3,
    shape = helpers.rrect(5),
  },
  widget = wibox.container.margin,
  bottom = 15,
  left = 15,
  right = 15,
}

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  if album_path == "" then
    album_path = beautiful.songdefpicture
  end
  if string.len(title) > 30 then
    title = string.sub(title, 0, 30) .. "..."
  end
  if string.len(artist) > 22 then
    artist = string.sub(artist, 0, 22) .. "..."
  end
  art.image = helpers.cropSurface(2.92, gears.surface.load_uncached(album_path))
  helpers.gc(widget, "songname"):set_markup_silently(helpers.colorizeText(title or "NO", beautiful.fg))
  helpers.gc(widget, "artist"):set_markup_silently(helpers.colorizeText(artist or "HM", beautiful.fg))
end)
return widget
