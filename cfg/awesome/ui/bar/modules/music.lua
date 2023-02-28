local beautiful     = require("beautiful")
local awful         = require("awful")
local helpers       = require("helpers")
local wibox         = require("wibox")
local gears         = require("gears")
local dpi           = require("beautiful").xresources.apply_dpi
local bling         = require("modules.bling")

local playerctl     = bling.signal.playerctl.cli()

local songname      = wibox.widget {
  font = beautiful.font,
  markup = " None ",
  valign = "center",
  align = "center",
  widget = wibox.widget.textbox,
}

local songnamebox   = wibox.widget {
  songname,
  width = dpi(100),
  widget = wibox.container.constraint

}
local play_button   = wibox.widget {
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('song::toggle')
    end)
  },
  image = beautiful.play,
  widget = wibox.widget.imagebox
}

local toggle        = wibox.widget {
  play_button,
  margins = 4,
  widget = wibox.container.margin
}

local music_control = wibox.widget {
  songnamebox,
  toggle,
  spacing = 10,
  layout = wibox.layout.fixed.horizontal,
}

local horiz         = wibox.widget {
  {
    {
      music_control,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = 6,
    widget = wibox.container.margin,
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background,
}

local vert          = wibox.widget {
  {
    {
      {
        {
          {
            id = "image",
            align = 'center',
            clip_shape = helpers.rrect(50),
            forced_height = 20,
            forced_width = 20,
            opacity = 0.75,
            widget = wibox.widget.imagebox,
          },
          halign = 'center',
          widget = wibox.container.place
        },
        margins = {
          bottom = 5
        },
        widget = wibox.container.margin
      },
      {
        align = 'center',
        font = beautiful.icofont .. " 16",
        text = '󰒮',
        widget = wibox.widget.textbox,
        buttons = {
          awful.button({}, 1, function()
            playerctl:previous()
          end)
        }
      },
      {
        id = 'play_pause',
        align = 'center',
        font = beautiful.icofont .. " 16",
        markup = helpers.colorizeText('󰐊', beautiful.fg),
        widget = wibox.widget.textbox,
        buttons = {
          awful.button({}, 1, function()
            playerctl:play_pause()
          end)
        },

      },
      {
        align = 'center',
        font = beautiful.icofont .. " 16",
        text = '󰒭',
        widget = wibox.widget.textbox,
        buttons = {
          awful.button({}, 1, function()
            playerctl:next()
          end)
        },

      },
      spacing = 8,
      layout = wibox.layout.fixed.vertical,
    },
    margins = {
      top = dpi(8),
      bottom = dpi(8)
    },
    widget = wibox.container.margin
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background,
}

playerctl:connect_signal("playback_status", function(_, playing, _)
  if playing then
    play_button.image = beautiful.pause
  else
    play_button.image = beautiful.play
  end
  vert:get_children_by_id('play_pause')[1].markup = playing and helpers.colorizeText("󰏤", beautiful.fg) or
      helpers.colorizeText("󰐊", beautiful.fg)
end)

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album)
  if title == "" then
    title = " None "
  end

  vert:get_children_by_id('image')[1].image = helpers.cropSurface(1, gears.surface.load_uncached(album_path))
  songname:set_markup_silently(" " .. title .. " ")
end)

awesome.connect_signal("song::toggle", function()
  playerctl:play_pause()
end)

local widget = nil

if beautiful.barDir == 'left' or beautiful.barDir == 'right' then
  widget = vert
else
  widget = horiz
end
return widget
