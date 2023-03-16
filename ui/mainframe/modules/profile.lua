local wibox          = require("wibox")
local beautiful      = require("beautiful")
local dpi            = require("beautiful").xresources.apply_dpi
local helpers        = require("helpers")
local awful          = require('awful')

local profilepicture = wibox.widget {
  image         = beautiful.profilepicture,
  opacity       = 0.65,
  clip_shape    = helpers.rrect(4),
  forced_height = 80,
  forced_width  = 80,
  widget        = wibox.widget.imagebox
}
local uptime         = wibox.widget {
  font = beautiful.font .. " 11",
  markup = helpers.colorizeText("4h 45m", beautiful.fg3),
  widget = wibox.widget.textbox,
}
local name           = wibox.widget {
  nil,
  {
    {
      font = beautiful.font .. " Bold 14",
      markup = helpers.colorizeText("Welcome!", beautiful.fg .. 'cc'),
      widget = wibox.widget.textbox,
    },
    {
      font = beautiful.font .. " 13",
      markup = "chadcat#5207",
      widget = wibox.widget.textbox,
    },
    spacing = 3,
    layout = wibox.layout.fixed.vertical,
  },
  layout = wibox.layout.align.vertical,
  expand = "none"
}
local batval         = wibox.widget {
  font = beautiful.font .. " 13",
  markup = helpers.colorizeText("15", beautiful.pri),
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
}
local battery        = wibox.widget {
  batval,
  widget = wibox.container.arcchart,
  max_value = 100,
  min_value = 0,
  value = 69,
  rounded_edge = true,
  thickness = dpi(4.5),
  start_angle = 4.71238898,
  bg = beautiful.pri .. "4D",
  colors = { beautiful.pri },
  forced_width = dpi(70),
  forced_height = dpi(70)
}

local createProg     = function(value, color, signal)
  local progress = wibox.widget {
    max_value        = 100,
    value            = value,
    forced_height    = 20,
    forced_width     = 100,
    shape            = helpers.rrect(10),
    bar_shape        = helpers.rrect(10),
    color            = color,
    background_color = beautiful.bg2 .. '00',
    paddings         = 1,
    widget           = wibox.widget.progressbar,
  }
  awesome.connect_signal('signal::' .. signal, function(val)
    progress.value = val
  end)
  return wibox.widget {
    progress,
    forced_height = 150,
    forced_width  = 8,
    direction     = 'east',
    layout        = wibox.container.rotate,
  }
end


local createButton    = function(icon, cmd, color)
  local button = wibox.widget {
    {
      {
        id = 'text_role',
        align = 'center',
        font = beautiful.icofont .. " 20",
        markup = helpers.colorizeText(icon, color),
        widget = wibox.widget.textbox
      },
      margins = 5,
      widget = wibox.container.margin
    },
    buttons = {
      awful.button({}, 1, function()
        cmd()
      end)
    },
    widget = wibox.container.background
  }

  return button
end

local poweroffcommand = function()
  awful.spawn.with_shell("poweroff")
  awesome.emit_signal('hide::exit')
end

local rebootcommand   = function()
  awful.spawn.with_shell("reboot")
  awesome.emit_signal('hide::exit')
end

local suspendcommand  = function()
  awesome.emit_signal('hide::exit')
  awful.spawn.with_shell("systemctl suspend")
end

local exitcommand     = function()
  awesome.quit()
end

local lockcommand     = function()
  awesome.emit_signal('hide::exit')
  awful.spawn.with_shell("lock")
end

local powerofficon    = "󰐥"
local rebooticon      = "󰦛"
local suspendicon     = "󰤄"
local exiticon        = "󰈆"
local lockicon        = "󰍁"

local poweroffbutton  = createButton(powerofficon, poweroffcommand, beautiful.fg .. 'cc')
local lockbutton      = createButton(lockicon, lockcommand, beautiful.fg .. 'cc')
local rebootbutton    = createButton(rebooticon, rebootcommand, beautiful.fg .. 'cc')
local exitbutton      = createButton(exiticon, exitcommand, beautiful.fg .. 'cc')

local batteryprog     = createProg(49, beautiful.ok, 'battery')
local memprog         = createProg(23, beautiful.warn, 'memory')
local diskprog        = createProg(43, beautiful.err, 'disk')
local cpuprog         = createProg(69, beautiful.dis, 'cpu')
local finalwidget     = wibox.widget {
  {
    {
      {
        {
          {
            uptime,
            name,
            spacing = 5,
            layout = wibox.layout.fixed.vertical
          },
          profilepicture,
          spacing = 70,
          layout = wibox.layout.fixed.horizontal,
        },
        {
          {
            {
              poweroffbutton,
              rebootbutton,
              lockbutton,
              exitbutton,
              spacing = 25,
              layout  = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.margin,
            margins = 14,
          },
          widget = wibox.container.background,
          bg = beautiful.bg3
        },
        spacing = 20,
        layout = wibox.layout.fixed.vertical
      },
      margins = 25,
      widget = wibox.container.margin,
    },
    bg = beautiful.bg2 .. 'cc',
    widget = wibox.container.background
  },
  {
    {
      {
        cpuprog,
        diskprog,
        batteryprog,
        memprog,
        spacing = 12,
        layout = wibox.layout.fixed.horizontal
      },
      margins = {
        top = 15,
        bottom = 15,
        left = 25,
        right = 25,
      },
      widget = wibox.container.margin,
    },
    bg = beautiful.bg2 .. 'cc',
    widget = wibox.container.background
    --   {
    --     {
    --       {
    --         font = beautiful.font .. " 11",
    --         markup = helpers.colorizeText("BAT", beautiful.fg3),
    --         widget = wibox.widget.textbox,
    --       },
    --       margins = { left = 15, top = 15, },
    --       widget = wibox.container.margin
    --     },
    --     {
    --       battery,
    --       margins = {
    --         left = 30, right = 30, bottom = 10,
    --       },
    --       widget = wibox.container.margin
    --     },
    --     spacing = 5,
    --     layout = wibox.layout.fixed.vertical
    --   },
    --   bg = beautiful.bg2 .. 'cc',
    --   widget = wibox.container.background
  },
  spacing = 20,
  layout = wibox.layout.fixed.horizontal
}

awesome.connect_signal("signal::battery", function(value)
  batval.markup = helpers.colorizeText(tostring(value), beautiful.pri)
  battery.value = value
end)

awesome.connect_signal("signal::uptime", function(value)
  uptime.markup = helpers.colorizeText(value, beautiful.fg3)
end)
return finalwidget
