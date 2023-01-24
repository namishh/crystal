local wibox     = require("wibox")
local awful     = require("awful")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local gears     = require("gears")
local bling     = require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib()
local art       = wibox.widget {
  image = beautiful.songdefpicture,
  opacity = 0.25,
  forced_height = dpi(240),
  forced_width = dpi(365),
  widget = wibox.widget.imagebox
}

local songname = wibox.widget {
  markup = 'Nothing Playing',
  align = 'left',
  valign = 'center',
  font = beautiful.font .. " 14",
  forced_width = dpi(40),
  widget = wibox.widget.textbox
}
local artistname = wibox.widget {
  markup = 'None',
  align = 'left',
  valign = 'center',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local currentpos = wibox.widget {
  markup = '0:00',
  align = 'left',
  valign = 'bottom',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local sep = wibox.widget {
  markup = helpers.colorizeText(' / ', beautiful.pri),
  align = 'center',
  valign = 'bottom',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local tpos = wibox.widget {
  markup = '0:00',
  align = 'left',
  valign = 'bottom',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local prev = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 28",
  text = '󰒮',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}

local player = wibox.widget {
  valign = 'bottom',
  align = 'end',
  font = beautiful.font,
  text = 'none',
  widget = wibox.widget.textbox,
}
local next = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 28",
  text = '󰒭',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local play = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 26",
  markup = helpers.colorizeText('󰐊', beautiful.pri),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}

local finalwidget = wibox.widget {
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
          to = { 190, 0 },
          stops = { { 0, beautiful.bg .. "00" }, { 1, "#181817" } }
        },
        widget = wibox.container.background,
      },
      {
        {
          {

            songname,
            artistname,
            spacing = 3,
            layout = wibox.layout.fixed.vertical,
          },
          {
            { currentpos,
              sep,
              layout = wibox.layout.fixed.horizontal,
            },
            tpos,
            player,
            layout = wibox.layout.align.horizontal,
          },
          layout = wibox.layout.align.vertical,
        },
        widget = wibox.container.margin,
        margins = dpi(15)
      },
      layout = wibox.layout.stack,
    },
    {
      {
        {
          {
            prev,
            {
              {
                play,
                widget = wibox.container.margin,
                margins = 5,
              },
              shape = helpers.rrect(4),
              widget = wibox.container.background,
              bg = beautiful.pri .. "11"
            },
            next,
            expand = 'none',
            layout = wibox.layout.align.vertical,
          },
          widget = wibox.container.margin,
          margins = dpi(10)
        },
        bg = beautiful.bg2 .. 'cc',
        widget = wibox.container.background,
      },
      widget = wibox.container.margin,
      margins = {
        left = 20,
      }
    },
    layout = wibox.layout.align.horizontal,
  },
  widget = wibox.container.margin,
  margins = dpi(0)
}

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  -- Set art widget
  if title == "" then
    title = "None"
  end
  if artist == "" then
    artist = "Unknown"
  end
  if album_path == "" then
    album_path = beautiful.songdefpicture
  end
  if string.len(title) > 30 then
    title = string.sub(title, 0, 30) .. "..."
  end
  if string.len(artist) > 22 then
    artist = string.sub(artist, 0, 22) .. "..."
  end
  songname:set_markup_silently(title)
  artistname:set_markup_silently(artist)
  art:set_image(gears.surface.load_uncached(album_path))
end)

playerctl:connect_signal("position", function(_, interval_sec, length_sec, player_name)
  if interval_sec > 0 then
    tpos.markup = os.date("!%M:%S", tonumber(length_sec))
    currentpos.markup = os.date("!%M:%S", tonumber(interval_sec))
  else
    tpos.markup = "00:00"
    currentpos.markup = "00:00"
  end
end)

playerctl:connect_signal("playback_status", function(_, playing, player_name)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.pri) or helpers.colorizeText("󰐊", beautiful.pri)
  player.markup = player_name
end)

return finalwidget
