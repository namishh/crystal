local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi

-- Importing all the compoments
local layoutbox   = require("ui.bar.modules.layout")
local taglist     = require("ui.bar.modules.tags")
local systraybox  = require("ui.bar.modules.tray")
local tasklist    = require("ui.bar.modules.tasklist")
local status      = require("ui.bar.modules.status")
local time        = require("ui.bar.modules.time")
local music       = require("ui.bar.modules.music")
local launcher    = require("ui.bar.modules.misc").launcher
local powerbutton = require("ui.bar.modules.misc").powerbutton

local barheight   = beautiful.scrheight
local barwidth    = beautiful.scrwidth
local alignlayout = nil
local fixedlayout = nil
if beautiful.barDir == 'left' or beautiful.barDir == 'right' then
  barwidth = dpi(50)
  alignlayout = wibox.layout.align.vertical
  fixedlayout = wibox.layout.fixed.vertical
else
  barheight = dpi(50)
  alignlayout = wibox.layout.align.horizontal
  fixedlayout = wibox.layout.fixed.horizontal
end

local function init(s)
  local wibar = awful.wibar {
    position = beautiful.barDir,
    height = barheight,
    width = barwidth,
    bg = beautiful.bg,
    fg = beautiful.fg1,
    screen = s,
    widget = {
      layout = alignlayout,
      {
        -- Left
        {
          layout = fixedlayout,
          launcher,
          {
            {
              {
                taglist(s),
                forced_width = 159,
                widget = wibox.container.margin,
                margins = {
                  left = dpi(13),
                  right = dpi(13),
                  top = dpi(13),
                  bottom = dpi(13)
                },
              },
              widget = wibox.container.place
            },
            bg = beautiful.bg2,
            widget = wibox.container.background
          },
          layoutbox,
          tasklist(s),
          spacing = 7,
        },
        top = dpi(8),
        bottom = dpi(5),
        right = dpi(7),
        left = dpi(7),
        widget = wibox.container.margin
      },
      nil,
      {
        --Right
        {
          systraybox,
          status,
          music,
          time,
          powerbutton,
          spacing = 7,
          layout = fixedlayout,
        },
        top = dpi(8),
        bottom = dpi(5),
        right = dpi(7),
        left = dpi(7),
        widget = wibox.container.margin
      },
    }
  }
  return wibar
end

screen.connect_signal('request::desktop_decoration', function(s)
  s.wibox = init(s)
end)
