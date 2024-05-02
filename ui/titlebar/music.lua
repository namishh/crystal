local awful = require 'awful'
require 'awful.autofocus'
local wibox           = require 'wibox'
local gears           = require 'gears'
local beautiful       = require("beautiful")
local ruled           = require("ruled")
local helpers         = require("helpers")
local playerctl       = require("mods.playerctl").lib()
local dpi             = beautiful.xresources.apply_dpi

local art             = wibox.widget {
  image = helpers.cropSurface(1, gears.surface.load_uncached(beautiful.songdefpicture)),
  clip_shape = helpers.rrect(10),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(220),
  forced_width = dpi(220),
  valign = 'center',
  widget = wibox.widget.imagebox
}
local prev            = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 20",
  markup = helpers.colorizeText('󰒮', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local next            = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 20",
  markup = helpers.colorizeText('󰒭', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local play            = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 20",
  markup = helpers.colorizeText('󰐊', beautiful.blue),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}
local createHandle    = function(width, height, tl, tr, br, bl, radius)
  return function(cr)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end
local slider          = wibox.widget {
  bar_shape        = helpers.rrect(0),
  bar_height       = 3,
  handle_color     = beautiful.fg2,
  bar_color        = beautiful.fg3,
  bar_active_color = beautiful.fg2,
  handle_shape     = createHandle(18, 3, false, false, false, false, 0),
  handle_margins   = { top = 3 },
  handle_width     = 18,
  forced_height    = 10,
  maximum          = 100,
  widget           = wibox.widget.slider,
}

local songname        = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  align = 'center',
  valign = 'center',
  forced_width = dpi(120),
  font = beautiful.sans .. " 14",
  widget = wibox.widget.textbox
}
local artistname      = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.comm),
  align = 'center',
  valign = 'center',
  forced_height = dpi(20),
  font = beautiful.sans .. " 12",
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
  slider.maximum = length_sec or 100
  slider.value = interval_sec or 0
end)

playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  if player_name == "mpd" then
    if album_path == "" then
      album_path = beautiful.songdefpicture
    end
    if string.len(title) > 30 then
      title = string.sub(title, 0, 30) .. "..."
    end
    if string.len(artist) > 22 then
      artist = string.sub(artist, 0, 22) .. "..."
    end
    songname:set_markup_silently(helpers.colorizeText(title or "NO", beautiful.fg))
    artistname:set_markup_silently(helpers.colorizeText(artist or "HM", beautiful.comm))
    art:set_image(gears.surface.load_uncached(album_path))
  end
end)


playerctl:connect_signal("playback_status", function(_, playing)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.blue) or helpers.colorizeText("󰐊", beautiful.blue)
end)
local createTopButton = function(c, icon, click, color)
  local widget = wibox.widget {
    {
      {
        markup = helpers.colorizeText(icon, color),
        valign = 'center',
        forced_height = dpi(20),
        font = beautiful.icon .. " 18",
        widget = wibox.widget.textbox
      },
      margins = {
        left = 8,
        right = 8
      },
      widget = wibox.container.margin,
    },
    buttons = awful.button({}, 1, function()
      helpers.clickKey(c, click)
    end),
    bg = beautiful.mbg,
    widget = wibox.container.background
  }
  return widget
end

local shufflebtn = wibox.widget {
  align = 'center',
  forced_height = 25,
  image = beautiful.shuffle_off,
  widget = wibox.widget.imagebox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:cycle_shuffle()
    end)
  }
}
playerctl:connect_signal("shuffle", function(_, shuffle)
  shufflebtn.image = shuffle and beautiful.shuffle_on or beautiful.shuffle_off
end)

local repeatt = wibox.widget {
  align = 'center',
  forced_height = 25,
  image = beautiful.no_repeat,
  widget = wibox.widget.imagebox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:cycle_loop_status()
    end)
  }
}
playerctl:connect_signal("loop_status", function(_, loop_status)
  if loop_status:match('none') then
    repeatt.image = beautiful.no_repeat
  elseif loop_status:match('track') then
    repeatt.image = beautiful.repeat_song
  else
    repeatt.image = beautiful.repeat_play
  end
end)


local right = function(c)
  local playtab = createTopButton(c, '󰲸', '1', beautiful.blue)
  local vistab = createTopButton(c, '󰐰', '8', beautiful.blue)
  vistab:add_button(awful.button({}, 3, function()
    helpers.clickKey(c, '8 ')
  end))
  awful.titlebar(c, { position = "right", size = dpi(300), bg = beautiful.mbg }):setup {
    {
      {
        {
          {
            art,
            widget = wibox.container.margin,
            bottom = 10,
          },
          widget = wibox.container.place,
          halign = "center",
        },
        {
          {
            {
              {
                {
                  shufflebtn,
                  widget = wibox.container.place,
                  halign = "right",
                },
                widget = wibox.container.place,
                halign = "center",
              },
              {
                {
                  {
                    spacing = 20,
                    layout = wibox.layout.fixed.horizontal,
                    prev,
                    play,
                    next
                  },
                  widget = wibox.container.margin,
                  left = 20,
                  right = 20,
                  top = 8,
                  bottom = 8
                },
                shape = helpers.rrect(15),
                widget = wibox.container.background,
                bg = beautiful.blue .. '11'
              },
              {
                repeatt,
                widget = wibox.container.place,
                valign = "center",
              },
              spacing = 20,
              layout = wibox.layout.fixed.horizontal,
            },
            widget = wibox.container.place,
            halign = "center",
          },
          widget = wibox.container.margin,
          bottom = 10,
        },
        {
          songname,
          artistname,
          spacing = 3,
          layout = wibox.layout.fixed.vertical,
        },
        spacing = 10,
        layout = wibox.layout.fixed.vertical,
      },
      widget = wibox.container.place,
      halign = "center",
      valign = "center",
    },
    widget = wibox.container.margin,
    left = 20,
    top = 15,
    bottom = 15,
    right = 20
  }
end

local final = function(c)
  right(c)
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
