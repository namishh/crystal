local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local pctl      = require("mods.playerctl")
local helpers   = require("helpers")
local playerctl = pctl.lib()
local art       = wibox.widget {
  image = helpers.cropSurface(5.8, gears.surface.load_uncached(beautiful.songdefpicture)),
  opacity = 0.3,
  forced_height = dpi(36),
  shape = helpers.rrect(5),
  forced_width = dpi(240),
  widget = wibox.widget.imagebox
}
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  -- Set art widget
  art.image = helpers.cropSurface(5.8, gears.surface.load_uncached(album_path))
end)
local next = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 18",
  text = '󰒭',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local prev = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 18",
  text = '󰒮',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local play = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 20",
  markup = helpers.colorizeText('󰐊', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}
playerctl:connect_signal("playback_status", function(_, playing, player_name)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.fg) or helpers.colorizeText("󰐊", beautiful.fg)
end)
local finalwidget = wibox.widget {
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
        stops = { { 0, beautiful.bg .. "00" }, { 1, beautiful.mbg } }
      },
      widget = wibox.container.background,
    },
    {
      {
        {
          align = 'center',
          font = beautiful.icon .. " 18",
          markup = helpers.colorizeText('󰋎', beautiful.fg),
          widget = wibox.widget.textbox,
        },
        nil,
        { prev, play, next, spacing = 8, layout = wibox.layout.fixed.horizontal },
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      left = 6,
      right = 6,
    },
    layout = wibox.layout.stack,
  },
  widget = wibox.container.background,
  shape = helpers.rrect(5),
}

return finalwidget
