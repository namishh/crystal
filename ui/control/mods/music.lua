local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local pctl      = require("mods.playerctl")
local helpers   = require("helpers")
local playerctl = pctl.lib()
local art       = wibox.widget {
  image = helpers.cropSurface(1.71, gears.surface.load_uncached(beautiful.songdefpicture)),
  opacity = 0.3,
  resize = true,
  clip_shape = helpers.rrect(12),
  widget = wibox.widget.imagebox
}
local next      = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 22",
  text = '󰒭',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local prev      = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 22",
  text = '󰒮',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local play      = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 22",
  markup = helpers.colorizeText('󰐍', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}
playerctl:connect_signal("playback_status", function(_, playing, player_name)
  play.markup = playing and helpers.colorizeText("󰏦", beautiful.fg) or helpers.colorizeText("󰐍", beautiful.fg)
end)
local finalwidget = wibox.widget {

  {
    nil,
    {
      art,
      {
        {
          widget = wibox.widget.textbox,
        },
        bg = {
          type = "linear",
          from = { 0, 0 },
          to = { 250, 0 },
          stops = { { 0, beautiful.bg .. "ff" }, { 1, beautiful.mbg .. '55' } }
        },
        shape = helpers.rrect(12),
        widget = wibox.container.background,
      },
      {
        {
          {
            {
              id = "songname",
              font = beautiful.sans .. " 14",
              markup = helpers.colorizeText('Song Name', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            {
              id = "artist",
              font = beautiful.sans .. " 12",
              markup = helpers.colorizeText('Artist Name', beautiful.fg),
              widget = wibox.widget.textbox,
            },
            spacing = 8,
            layout = wibox.layout.fixed.vertical,
          },
          nil,
          {
            id = "player",
            font = beautiful.sans .. " 12",
            markup = helpers.colorizeText('Playing Via Spotify', beautiful.fg),
            widget = wibox.widget.textbox,
          },
          layout = wibox.layout.align.vertical
        },
        widget = wibox.container.margin,
        margins = 20
      },
      layout = wibox.layout.stack,
    },
    {
      {
        {
          {
            prev,
            play,
            next,
            layout = wibox.layout.align.vertical,
          },
          widget = wibox.container.margin,
          top = 25,
          bottom = 25,
          left = 20,
          right = 20,
        },
        shape = helpers.rrect(12),
        widget = wibox.container.background,
        bg = beautiful.mbg,
      },
      widget = wibox.container.margin,
      left = 20,
    },
    layout = wibox.layout.align.horizontal,
  },
  widget = wibox.container.margin,
  margins = 20,
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
  art.image = helpers.cropSurface(1.71, gears.surface.load_uncached(album_path))
  helpers.gc(finalwidget, "songname"):set_markup_silently(helpers.colorizeText(title or "NO", beautiful.fg))
  helpers.gc(finalwidget, "artist"):set_markup_silently(helpers.colorizeText(artist or "HM", beautiful.fg))
  helpers.gc(finalwidget, "player"):set_markup_silently(helpers.colorizeText("Playing Via: " .. player_name or "",
    beautiful.fg))
end)
return finalwidget
