local wibox       = require("wibox")
local awful       = require("awful")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local gears       = require("gears")
local bling       = require("modules.bling")
local helpers     = require("helpers")
local playerctl   = bling.signal.playerctl.lib()
local art         = wibox.widget {
  image = beautiful.songdefpicture,
  opacity = 0.25,
  forced_height = dpi(210),
  forced_width = dpi(365),
  widget = wibox.widget.imagebox
}
local createStick = function(height)
  return wibox.widget {
    {
      valign = 'center',
      shape = helpers.rrect(6),
      forced_height = height,
      forced_width = 3,
      bg = beautiful.fg .. 'cc',
      widget = wibox.container.background
    },
    widget = wibox.container.place,
  }
end
local visualizer  = wibox.widget {
  createStick(20),
  createStick(10),
  createStick(15),
  createStick(19),
  createStick(8),
  createStick(23),
  spacing = 4,
  layout = wibox.layout.fixed.horizontal,
}
local songname    = wibox.widget {
  markup = 'Nothing Playing',
  align = 'left',
  valign = 'center',
  font = beautiful.font .. " 13",
  forced_width = dpi(40),
  widget = wibox.widget.textbox
}
local artistname  = wibox.widget {
  markup = 'None',
  align = 'left',
  valign = 'center',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local status = wibox.widget {
  markup = 'Paused',
  align = 'left',
  valign = 'bottom',
  forced_height = dpi(20),
  widget = wibox.widget.textbox
}

local prev = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 24",
  text = '󰒮',
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}

local slider = wibox.widget {
  bar_shape        = helpers.rrect(0),
  bar_height       = 6,
  handle_color     = beautiful.dis,
  bar_color        = beautiful.dis .. '11',
  bar_active_color = beautiful.dis,
  handle_shape     = gears.shape.rectangle,
  handle_width     = 8,
  forced_height    = 6,
  forced_width     = 100,
  maximum          = 100,
  widget           = wibox.widget.slider,
}
local is_prog_hovered = false
slider:connect_signal('mouse::enter', function()
  is_prog_hovered = true
end)
slider:connect_signal('mouse::leave', function()
  is_prog_hovered = false
end)
slider:connect_signal('property::value', function(_, value)
  if is_prog_hovered then
    playerctl:set_position(value)
  end
end)
playerctl:connect_signal("position", function(_, interval_sec, length_sec)
  slider.maximum = length_sec
  slider.value = interval_sec
end)
local next = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 24",
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
  font = beautiful.icofont .. " 23",
  markup = helpers.colorizeText('󰐊', beautiful.fg),
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
        nil,
        {
          {
            {

              songname,
              artistname,
              spacing = 3,
              layout = wibox.layout.fixed.vertical,
            },
            nil,
            {
              status,
              nil,
              visualizer,
              layout = wibox.layout.align.horizontal,
            },
            expand = 'none',
            layout = wibox.layout.align.vertical,
          },
          widget = wibox.container.margin,
          margins = dpi(15)
        },
        slider,
        layout = wibox.layout.align.vertical
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
              bg = beautiful.fg .. "11"
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
end)
playerctl:connect_signal("playback_status", function(_, playing, player_name)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.fg) or helpers.colorizeText("󰐊", beautiful.fg)
  status.markup = playing and "Playing" or "Paused"
end)

return finalwidget
