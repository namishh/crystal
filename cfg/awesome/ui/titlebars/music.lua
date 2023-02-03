local awful = require 'awful'
require 'awful.autofocus'
local wibox     = require 'wibox'
local gears     = require 'gears'
local beautiful = require("beautiful")
local ruled     = require("ruled")
local bling     = require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib()
local dpi       = beautiful.xresources.apply_dpi

local art = wibox.widget {
  image = beautiful.songdefpicture,
  clip_shape = helpers.rrect(6),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(80),
  forced_width = dpi(80),
  widget = wibox.widget.imagebox
}

local prev = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 24",
  markup = helpers.colorizeText('󰒮', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local next = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 24",
  markup = helpers.colorizeText('󰒭', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local play = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 24",
  markup = helpers.colorizeText('󰐊', beautiful.pri),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}

local createHandle = function(width, height, tl, tr, br, bl, radius)
  return function(cr)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end
local slider = wibox.widget {
  bar_shape        = helpers.rrect(0),
  bar_height       = 3,
  handle_color     = beautiful.pri,
  bar_color        = beautiful.pri .. '33',
  bar_active_color = beautiful.pri,
  handle_shape     = createHandle(18, 3, false, false, false, false, 0),
  handle_margins   = { top = 3 },
  handle_width     = 18,
  forced_height    = 10,
  maximum          = 100,
  widget           = wibox.widget.slider,
}

local volslider = wibox.widget {
  bar_shape        = helpers.rrect(50),
  bar_height       = 20,
  handle_color     = beautiful.dis,
  handle_shape     = createHandle(20, 20, false, true, true, false, 20),
  handle_width     = 20,
  bar_color        = beautiful.dis .. '33',
  bar_active_color = beautiful.dis,
  forced_height    = 8,
  forced_width     = 100,
  maximum          = 100,
  widget           = wibox.widget.slider,
}
local is_vol_hovered = false
volslider:connect_signal('property::value', function(_, value)
  playerctl:set_volume(value / 100)
end)
volslider:connect_signal('mouse::enter', function()
  is_vol_hovered = true
end)
volslider:connect_signal('mouse::leave', function()
  is_vol_hovered = false
end)
playerctl:connect_signal("volume", function(_, volume, _)
  volslider.value = not is_vol_hovered and volume
end)
local songname = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  align = 'left',
  valign = 'center',
  forced_width = dpi(40),
  font = beautiful.font .. " 12",
  widget = wibox.widget.textbox
}
local artistname = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.fg),
  align = 'left',
  valign = 'center',
  forced_height = dpi(20),
  font = beautiful.font .. " 11",
  widget = wibox.widget.textbox
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
  songname:set_markup_silently(helpers.colorizeText(title, beautiful.fg))
  artistname:set_markup_silently(helpers.colorizeText(artist, beautiful.fg))
  art:set_image(gears.surface.load_uncached(album_path))
end)

playerctl:connect_signal("playback_status", function(_, playing)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.pri) or helpers.colorizeText("󰐊", beautiful.pri)
end)

local bottom = function(c)
  awful.titlebar(c, { position = "bottom", size = dpi(100), bg = beautiful.bg }):setup {
    slider,
    {
      {
        {
          art,
          {
            {
              songname,
              artistname,
              forced_width = 400,
              layout = wibox.layout.fixed.vertical,
            },
            align = 'center',
            widget = wibox.container.place
          },
          layout = wibox.layout.fixed.horizontal,
        },
        margins = 10,
        widget = wibox.container.margin,
      },
      {
        {
          prev,
          {
            {
              play,
              margins = 4,
              widget = wibox.container.margin
            },
            shape = helpers.rrect(3),
            bg = beautiful.pri .. '11',
            widget = wibox.container.background
          },
          next,
          spacing = 10,
          layout = wibox.layout.fixed.horizontal,
        },
        align = 'center',
        widget = wibox.container.place,
      },
      {
        {
          {
            font = beautiful.icofont .. " 20",
            markup = helpers.colorizeText("󰕾", beautiful.fg),
            widget = wibox.widget.textbox,
          },
          volslider,
          spacing = 10,
          layout = wibox.layout.fixed.horizontal,
        },
        margins = {
          top = 35,
          bottom = 35,
          left = 10,
          right = 10,
        },
        widget = wibox.container.margin
      },
      expand = 'none',
      layout = wibox.layout.align.horizontal,
    },
    layout = wibox.layout.fixed.vertical,
  }
end

local final = function(c)
  bottom(c)
end


ruled.client.connect_signal("request::rules", function()
  ruled.client.append_rule {
    id       = "music",
    rule_any = {
      class = { "ncmpcpppad" },
      role  = { "pop-up" },
    },
    callback = final
  }
end)
