-- Time Widget
local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local hourminutes = wibox.widget {
  {
    {
      font = beautiful.font,
      format = "%I : %M",
      align = "center",
      valign = "center",
      widget = wibox.widget.textclock
    },
    margins = { left = dpi(12), right = dpi(12) },
    widget = wibox.container.margin
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::notify')
    end)
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
  bg = beautiful.bg2 .. "cc"
}

local daymonths   = wibox.widget {
  {
    {
      font = beautiful.font,
      format = "%A, %d %b",
      align = "center",
      valign = "center",
      widget = wibox.widget.textclock
    },
    margins = { left = dpi(12), right = dpi(12) },
    widget = wibox.container.margin
  },
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('toggle::moment')
    end)
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
  bg = beautiful.bg2 .. "cc"
}

local horiz       = wibox.widget {
  {
    hourminutes,
    layout = wibox.layout.fixed.horizontal,
  },
  {
    daymonths,
    layout = wibox.layout.fixed.horizontal,
  },
  spacing = 6,
  layout = wibox.layout.fixed.horizontal,
}

local vert        = wibox.widget {
  {
    {
      {
        font = beautiful.font,
        format = "%I",
        align = "center",
        valign = "center",
        buttons = {
          awful.button({}, 1, function()
            awesome.emit_signal('toggle::notify')
          end)
        },
        widget = wibox.widget.textclock
      },
      {
        font = beautiful.font,
        format = "%M",
        align = "center",
        valign = "center",
        buttons = {
          awful.button({}, 1, function()
            awesome.emit_signal('toggle::moment')
          end)
        },
        widget = wibox.widget.textclock
      },
      spacing = 6,
      layout = wibox.layout.fixed.vertical,
    },
    margins = { bottom = dpi(12), top = dpi(12) },
    widget = wibox.container.margin
  },
  widget = wibox.container.background,
  shape = helpers.rrect(2),
  bg = beautiful.bg2 .. "cc"
}
local finaltimewidget

if beautiful.barDir == 'left' or beautiful.barDir == 'right' then
  finaltimewidget = vert
else
  finaltimewidget = horiz
end

return finaltimewidget
