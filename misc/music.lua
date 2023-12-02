local awful = require 'awful'
require 'awful.autofocus'
local wibox      = require 'wibox'
local gears      = require 'gears'
local beautiful  = require("beautiful")
local ruled      = require("ruled")
local helpers    = require("helpers")
local playerctl  = require("mods.playerctl").lib()
local dpi        = beautiful.xresources.apply_dpi

local art        = wibox.widget {
  image = beautiful.songdefpicture,
  clip_shape = helpers.rrect(10),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(60),
  forced_width = dpi(60),
  valign = 'center',
  widget = wibox.widget.imagebox
}
local leftart    = wibox.widget {
  image = beautiful.songdefpicture,
  clip_shape = helpers.rrect(10),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(250),
  forced_width = dpi(250),
  valign = 'center',
  widget = wibox.widget.imagebox
}
local prev       = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 24",
  markup = helpers.colorizeText('󰒮', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:previous()
    end)
  },
}
local next       = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 24",
  markup = helpers.colorizeText('󰒭', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:next()
    end)
  },
}

local play       = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 24",
  markup = helpers.colorizeText('󰐊', beautiful.blue),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:play_pause()
    end)
  },
}
local shufflebtn = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 13",
  markup = helpers.colorizeText('󰒝', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:cycle_shuffle()
    end)
  }
}
playerctl:connect_signal("shuffle", function(_, shuffle)
  shufflebtn.markup = shuffle and helpers.colorizeText('󰒝', beautiful.blue) or helpers.colorizeText('󰒝',
    beautiful.fg)
end)
local repeatt = wibox.widget {
  align = 'center',
  font = beautiful.icon .. " 13",
  markup = helpers.colorizeText('󰑖', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:cycle_loop_status()
    end)
  }
}
playerctl:connect_signal("loop_status", function(_, loop_status)
  if loop_status:match('none') then
    repeatt.markup = helpers.colorizeText('󰑖', beautiful.fg)
  elseif loop_status:match('track') then
    repeatt.markup = helpers.colorizeText('󰑘', beautiful.magenta)
  else
    repeatt.markup = helpers.colorizeText('󰑖', beautiful.magenta)
  end
end)

local createHandle = function(width, height, tl, tr, br, bl, radius)
  return function(cr)
    gears.shape.partially_rounded_rect(cr, width, height, tl, tr, br, bl, radius)
  end
end
local slider = wibox.widget {
  bar_shape        = helpers.rrect(0),
  bar_height       = 3,
  handle_color     = beautiful.blue,
  bar_color        = beautiful.blue .. '33',
  bar_active_color = beautiful.blue,
  handle_shape     = createHandle(18, 3, false, false, false, false, 0),
  handle_margins   = { top = 3 },
  handle_width     = 18,
  forced_height    = 10,
  maximum          = 100,
  widget           = wibox.widget.slider,
}

local songname = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  align = 'left',
  valign = 'center',
  forced_width = dpi(40),
  font = beautiful.sans .. " 12",
  widget = wibox.widget.textbox
}
local leftname = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  valign = 'center',
  align = 'center',
  font = beautiful.sans .. " 16",
  widget = wibox.widget.textbox
}
local artistname = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.fg),
  align = 'left',
  valign = 'center',
  forced_height = dpi(20),
  font = beautiful.sans .. " 11",
  widget = wibox.widget.textbox
}
local leftartist = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.fg),
  align = 'center',
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
    leftname:set_markup_silently(helpers.colorizeText(title or "NO", beautiful.fg))
    leftartist:set_markup_silently(helpers.colorizeText(' ' .. artist or "WT" .. ' ', beautiful.fg))
    artistname:set_markup_silently(helpers.colorizeText(artist or "HM", beautiful.fg))
    art:set_image(gears.surface.load_uncached(album_path))
    leftart:set_image(gears.surface.load_uncached(album_path))
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
  awful.titlebar(c, { position = "bottom", size = dpi(100), bg = beautiful.mbg }):setup {
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
            top = 15,
            bottom = 15,
            left = 10,
            right = 10,
          },
          widget = wibox.container.margin,
        },
        {
          {
            shufflebtn,
            prev,
            {
              {
                play,
                margins = 4,
                widget = wibox.container.margin
              },
              shape = helpers.rrect(3),
              bg = beautiful.blue .. '11',
              widget = wibox.container.background
            },
            next,
            repeatt,
            spacing = 15,
            layout = wibox.layout.fixed.horizontal,
          },
          align = 'center',
          widget = wibox.container.place,
        },
        {
          playtab,
          vistab,
          spacing = 10,
          layout = wibox.layout.fixed.horizontal,
        },
        expand = 'none',
        layout = wibox.layout.align.horizontal,
      },
      widget = wibox.container.margin,
      left = 15,
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
