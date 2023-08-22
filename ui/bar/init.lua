local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require('helpers')
-- Importing all the compoments
local layoutbox   = require("ui.bar.modules.layout")
local taglist     = require("ui.bar.modules.tags")
local systraybox  = require("ui.bar.modules.tray")
local status      = require("ui.bar.modules.status")
local time        = require("ui.bar.modules.time")
local launcher    = require("ui.bar.modules.misc").launcher
local powerbutton = require("ui.bar.modules.misc").powerbutton
local music       = require("ui.bar.modules.music")
local barheight   = dpi(beautiful.barSize) - 2
local barwidth    = beautiful.barShouldHaveGaps == false and beautiful.scrwidth or
    beautiful.scrwidth - beautiful.barPadding
local alignlayout = wibox.layout.align.horizontal
local fixedlayout = wibox.layout.fixed.horizontal
local barMargin   = beautiful.barShouldHaveGaps and beautiful.barPadding or 0
local function init(s)
  local wibar = awful.wibar {
    position = beautiful.barDir,
    height = barheight,
    ontop = false,
    shape = barMargin == 0 and helpers.rrect(0) or helpers.rrect(5),
    width = barwidth,
    bg = beautiful.bg,
    margins = {
      -- work requiered TODO
      bottom = beautiful.barDir == 'top' and 0 or math.ceil(barMargin / 2),
      left = beautiful.barDir == 'right' and 0 or math.ceil(barMargin / 2),
      right = beautiful.barDir == 'left' and 0 or math.ceil(barMargin / 2),
      top = beautiful.barDir == 'bottom' and 0 or math.ceil(barMargin / 2),
    },
    fg = beautiful.fg1,
    screen = s,
    widget = {
      expand = 'none',
      layout = alignlayout,
      {
        -- Left
        {
          layout = fixedlayout,
          launcher,
          {
            {
              {
                {
                  taglist(s),
                  widget = wibox.container.margin,
                  margins = (beautiful.barDir == "top" or "bottom") and 8 or dpi(15),
                },
                widget = wibox.container.place,
                halign = 'center',
                valign = 'center'
              },
              bg = beautiful.bg2,
              widget = wibox.container.background
            },
            widget = wibox.container.margin
          },

          spacing = 7,
        },
        top = dpi(8),
        bottom = dpi(5),
        right = dpi(7),
        left = dpi(7),
        widget = wibox.container.margin
      },
      {
        music,
        widget = wibox.container.place,
        halign = "center"
      },
      {
        --Right
        {
          systraybox,
          status,
          time,
          layoutbox,
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
