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
  clip_shape = helpers.rrect(100),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(45),
  forced_width = dpi(45),
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
  align = 'left',
  valign = 'center',
  forced_width = dpi(40),
  font = beautiful.sans .. " 12",
  widget = wibox.widget.textbox
}
local artistname      = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.comm),
  align = 'left',
  valign = 'center',
  forced_height = dpi(20),
  font = beautiful.sans .. " 11",
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

local bottom          = function(c)
  local playtab = createTopButton(c, '󰲸', '1', beautiful.blue)
  local vistab = createTopButton(c, '󰐰', '8', beautiful.blue)
  vistab:add_button(awful.button({}, 3, function()
    helpers.clickKey(c, '8 ')
  end))
  awful.titlebar(c, { position = "bottom", size = dpi(70), bg = beautiful.mbg }):setup {
    slider,
    {
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
            spacing = 13,
            layout = wibox.layout.fixed.horizontal,
          },
          margins = {
            top = 5,
            bottom = 5,
            left = 5,
            right = 5,
          },
          widget = wibox.container.margin,
        },
        nil,
        {
          {
            {
              {
                {
                  prev,
                  play,
                  next,
                  spacing = 15,
                  layout = wibox.layout.fixed.horizontal,
                },
                align = 'center',
                widget = wibox.container.place,
              },
              widget = wibox.container.margin,
              left = 10,
              right = 10,
            },
            widget = wibox.container.background,
            bg = beautiful.mbg,
            shape_border_width = 1,
            shape_border_color = beautiful.fg3,
            shape = helpers.rrect(5),
          },
          widget = wibox.container.margin,
          margins = 5

        },
        expand = 'none',
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      left = 15,
      top = 5,
      bottom = 5,
      right = 15
    },
    layout = wibox.layout.fixed.vertical,
  }
end

local final           = function(c)
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
