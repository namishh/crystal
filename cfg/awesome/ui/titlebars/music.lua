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
  clip_shape = helpers.rrect(100),
  opacity = 0.75,
  resize = true,
  forced_height = dpi(180),
  forced_width = dpi(180),
  valign = 'center',
  widget = wibox.widget.imagebox
}
local prev       = wibox.widget {
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
local next       = wibox.widget {
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

local play       = wibox.widget {
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
local shufflebtn = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 13",
  markup = helpers.colorizeText('󰒝', beautiful.fg),
  widget = wibox.widget.textbox,
  buttons = {
    awful.button({}, 1, function()
      playerctl:cycle_shuffle()
    end)
  }
}
playerctl:connect_signal("shuffle", function(_, shuffle)
  shufflebtn.markup = shuffle and helpers.colorizeText('󰒝', beautiful.pri) or helpers.colorizeText('󰒝',
        beautiful.fg)
end)
local repeatt = wibox.widget {
  align = 'center',
  font = beautiful.icofont .. " 13",
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
    repeatt.markup = helpers.colorizeText('󰑘', beautiful.dis)
  else
    repeatt.markup = helpers.colorizeText('󰑖', beautiful.dis)
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

local songname = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  align = 'left',
  valign = 'center',
  forced_width = dpi(40),
  font = beautiful.font .. " 12",
  widget = wibox.widget.textbox
}
local leftname = wibox.widget {
  markup = helpers.colorizeText('Nothing Playing', beautiful.fg),
  valign = 'center',
  align = 'center',
  font = beautiful.font .. " 16",
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
local leftartist = wibox.widget {
  markup = helpers.colorizeText('None', beautiful.fg),
  align = 'center',
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
  leftname:set_markup_silently(helpers.colorizeText(title, beautiful.fg))
  leftartist:set_markup_silently(helpers.colorizeText(' ' .. artist .. ' ', beautiful.fg))
  artistname:set_markup_silently(helpers.colorizeText(artist, beautiful.fg))
  art:set_image(gears.surface.load_uncached(album_path))
  leftart:set_image(gears.surface.load_uncached(album_path))
end)


playerctl:connect_signal("playback_status", function(_, playing)
  play.markup = playing and helpers.colorizeText("󰏤", beautiful.pri) or helpers.colorizeText("󰐊", beautiful.pri)
end)
local createTopButton = function(c, icon, click, color)
  local widget = wibox.widget {
    {
      {
        markup = helpers.colorizeText(icon, color),
        valign = 'center',
        forced_height = dpi(20),
        font = beautiful.icofont .. " 18",
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
    bg = beautiful.bg,
    widget = wibox.container.background
  }
  return widget
end

local bottom = function(c)
  local playtab = createTopButton(c, '󰲸', '1', beautiful.pri)
  local vistab = createTopButton(c, '󰐰', '8', beautiful.pri)
  vistab:add_button(awful.button({}, 3, function()
    helpers.clickKey(c, '8 ')
  end))
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
            bg = beautiful.pri .. '11',
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
    layout = wibox.layout.fixed.vertical,
  }
end


local volslider = wibox.widget {
  bar_shape        = helpers.rrect(50),
  bar_height       = 18,
  handle_color     = beautiful.dis,
  handle_shape     = createHandle(18, 18, true, true, true, true, 50),
  handle_width     = 18,
  bar_color        = beautiful.dis .. '33',
  bar_active_color = beautiful.dis,
  handle_margins   = { top = beautiful.titlebarType == 'vert' and -1 or 6, },
  forced_height    = 10,
  value            = 100,
  forced_width     = 80,
  maximum          = 100,
  widget           = wibox.widget.slider,
}
local is_vol_hovered = false
playerctl:connect_signal("volume", function(_, volume, _)
  volslider.value = not is_vol_hovered and volume
end)
volslider:connect_signal('property::value', function(_, value)
  playerctl:set_volume(value / 100)
end)
volslider:connect_signal('mouse::enter', function()
  is_vol_hovered = true
end)
volslider:connect_signal('mouse::leave', function()
  is_vol_hovered = false
end)


local leftartcomplete = wibox.widget {
  {
    leftart,
    {
      {
        widget = wibox.container.background,
        bg = beautiful.fg .. 'cc',
        align = 'center',
        shape = helpers.rrect(100),
      },
      widget = wibox.container.margin,
      margins = 70,
    },
    {
      {
        widget = wibox.container.background,
        bg = beautiful.bg3,
        align = 'center',
        shape = helpers.rrect(100),
      },
      widget = wibox.container.margin,
      margins = 73,
    },
    layout = wibox.layout.stack
  },
  widget = wibox.container.place,
  halign = 'center'
}
local left            = function(c)
  awful.titlebar(c, { position = "right", size = dpi(280), bg = beautiful.bg }):setup {
    {
      {

        {
          leftartcomplete,
          widget = wibox.container.background,
          border_width = dpi(3),
          shape = gears.shape.circle,
          border_color = beautiful.fg2 .. 'cc'
        },
        {
          leftname,
          leftartist,
          spacing = 10,
          layout = wibox.layout.fixed.vertical
        },
        spacing = 20,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.place,
      halign = 'center',
      valign = 'center'
    },
    shape = helpers.prect(true, false, false, true, 15),
    bg = beautiful.bg2,
    widget = wibox.container.background
  }
end
local animation       = require("modules.animation")

local typee           = beautiful.titlebarType

local createButton    = function(c, col, fn)
  local btn = wibox.widget {
    forced_width  = 12,
    forced_height = 15,
    bg            = col,
    shape         = helpers.rrect(10),
    buttons       = {
      awful.button({}, 1, function()
        fn(c)
      end)
    },
    widget        = wibox.container.background
  }
  local anim = animation:new({
    duration = 0.12,
    easing = animation.easing.linear,
    update = function(_, pos)
      if typee == 'vert' then
        btn.forced_height = pos
      else
        btn.forced_width = pos
      end
    end,
  })
  btn:connect_signal('mouse::enter', function(_)
    anim:set(50)
  end)
  btn:connect_signal('mouse::leave', function(_)
    anim:set(15)
  end)
  return btn
end
local top             = function(c)
  local close = createButton(c, beautiful.err, function(c1)
    c1:kill()
  end)

  local maximize = createButton(c, beautiful.warn, function(c1)
    c1.maximized = not c1.maximized
  end)

  local minimize = createButton(c, beautiful.ok, function(c1)
    gears.timer.delayed_call(function()
      c1.minimized = not c1.minimized
    end)
  end)
  local buttons = gears.table.join(
    awful.button({}, 1, function()
      client.focus = c
      c:raise()
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      client.focus = c
      c:raise()
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c,
    {
      position = beautiful.titlebarType == 'vert' and 'left' or 'top',
      size = beautiful.titlebarType == 'vert' and 35 or 45,
      bg = beautiful.bg2
    }):setup {

    {
      {
        {
          close,
          maximize,
          minimize,
          spacing = dpi(8),
          layout = beautiful.titlebarType == 'vert' and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
        },
        widget = wibox.container.margin,
        margins = {
          top = 11.5,
          bottom = 11.5,
        }
      },
      { -- Middle
        buttons = buttons,
        widget = wibox.container.place,
        halign = 'center',
      },
      {
        {
          {
            font = beautiful.titlebarType == 'vert' and beautiful.icofont .. ' 0' or beautiful.icofont .. ' 17',
            markup = helpers.colorizeText("󰕾", beautiful.fg),
            widget = wibox.widget.textbox,
          },
          {
            volslider,
            forced_height = beautiful.titlebarType == 'vert' and 100 or 18,
            forced_width  = beautiful.titlebarType == 'vert' and 20 or 80,
            direction     = beautiful.titlebarType == 'vert' and 'east' or 'north',
            layout        = wibox.container.rotate,
          },
          spacing = 10,
          layout = beautiful.titlebarType == 'vert' and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
        },
        margins = {
          top = 5,
          bottom = 5,
          left = 0,
          right = 0,
        },
        widget = wibox.container.margin
      },
      layout = beautiful.titlebarType == 'vert' and wibox.layout.align.vertical or wibox.layout.align.horizontal
    },
    margins = {
      top = 0,
      bottom = 5,
      right = 10,
      left = 10,
    },
    widget = wibox.container.margin
  }
end

local final           = function(c)
  bottom(c)
  top(c)
  left(c)
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
