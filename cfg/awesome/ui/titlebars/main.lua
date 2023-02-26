local awful = require 'awful'
require 'awful.autofocus'
local wibox      = require 'wibox'
local gears      = require 'gears'
local helpers    = require("helpers")
local xresources = require("beautiful.xresources")
local dpi        = xresources.apply_dpi
local beautiful  = require("beautiful")
local animation  = require("modules.animation")

local typee      = beautiful.titlebarType
local titleVis   = true
if typee == 'vert' then
  titleVis = false
end

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
    anim:set(12)
  end)
  return btn
end

client.connect_signal("request::titlebars", function(c)
  -- buttons for the titlebar
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
  awful.titlebar(c, {
    size = typee == 'vert' and 35 or 27,
    position = typee == 'vert' and 'left' or 'top'
  }):setup {
    {
      {
        { -- Right
          {
            close,
            maximize,
            minimize,
            spacing = dpi(10),
            widget = wibox.container.place,
            halign = 'center',
            layout = typee == 'vert' and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
          },
          top = dpi(5),
          bottom = dpi(5),
          widget = wibox.container.margin
        },
        widget = wibox.container.place,
        halign = 'center',
      },
      { -- Middle
        buttons = buttons,
        layout = typee == 'vert' and wibox.layout.flex.vertical or wibox.layout.flex.horizontal
      },
      { -- Left
        { -- Title
          {
            align   = 'center',
            visible = titleVis,
            widget  = awful.titlebar.widget.titlewidget(c)
          },
          widget = wibox.container.constraint,
          width = dpi(350)

        },
        -- awful.titlebar.widget.iconwidget(c),
        buttons = buttons,
        layout = typee == 'vert' and wibox.layout.fixed.vertical or wibox.layout.fixed.horizontal
      },
      layout = typee == 'vert' and wibox.layout.align.vertical or wibox.layout.align.horizontal
    },
    right = dpi(10),
    left = dpi(10),
    top = dpi(0),
    bottom = dpi(5),
    widget = wibox.container.margin
  }
end)
