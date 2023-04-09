local awful = require 'awful'
require 'awful.autofocus'
local wibox        = require 'wibox'
local gears        = require 'gears'
local helpers      = require("helpers")
local xresources   = require("beautiful.xresources")
local dpi          = xresources.apply_dpi
local beautiful    = require("beautiful")
local animation    = require("modules.animation")

local createButton = function(c, col, fn)
  local btn = wibox.widget {
    forced_width  = 12,
    forced_height = 12,
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
      btn.forced_width = pos
    end,
  })
  btn:connect_signal('mouse::enter', function(_)
    anim:set(50)
  end)
  btn:connect_signal('mouse::leave', function(_)
    anim:set(12)
  end)
  return btn
end

client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
  local close = createButton(c, beautiful.err, function(c1)
    c1:kill()
  end)

  local maximize = createButton(c, beautiful.pri, function(c1)
    c1.maximized = not c1.maximized
  end)

  local minimize = createButton(c, beautiful.dis, function(c1)
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
  awful.titlebar(c, {
    size = 27,
    position = 'top'
  }):setup {
    {
      {
        {
          -- Right
          {
            close,
            maximize,
            minimize,
            spacing = dpi(10),
            widget = wibox.container.place,
            halign = 'center',
            layout = wibox.layout.fixed.horizontal
          },
          top = dpi(5),
          bottom = dpi(5),
          widget = wibox.container.margin
        },
        widget = wibox.container.place,
        halign = 'center',
      },
      {
        -- Middle
        buttons = buttons,
        layout = wibox.layout.flex.horizontal
      },
      {
        -- Left
        {
          -- Title
          {
            align  = 'center',
            widget = awful.titlebar.widget.titlewidget(c)
          },
          widget = wibox.container.constraint,
          width = dpi(350)
        },
        buttons = buttons,
        layout = wibox.layout.fixed.horizontal
      },
      layout = wibox.layout.align.horizontal
    },
    right = dpi(10),
    left = dpi(10),
    top = dpi(0),
    bottom = dpi(5),
    widget = wibox.container.margin
  }
end)
