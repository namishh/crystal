local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require('helpers')
-- Importing all the compoments
local layoutbox   = require("ui.bar.modules.layout")
local taglist     = require("ui.bar.modules.tags")
local systraybox  = require("ui.bar.modules.tray")
local tasklist    = require("ui.bar.modules.tasklist")
local status      = require("ui.bar.modules.status")
local time        = require("ui.bar.modules.time")
local launcher    = require("ui.bar.modules.misc").launcher
local powerbutton = require("ui.bar.modules.misc").powerbutton

local barheight   = beautiful.scrheight
local barwidth    = beautiful.scrwidth
local alignlayout = nil
local fixedlayout = nil
if beautiful.barDir == 'left' or beautiful.barDir == 'right' then
  barwidth = dpi(beautiful.barSize)
  barheight = beautiful.barShouldHaveGaps == false and barheight or barheight - beautiful.barPadding
  alignlayout = wibox.layout.align.vertical
  fixedlayout = wibox.layout.fixed.vertical
else
  barheight = dpi(beautiful.barSize) - 5
  barwidth = beautiful.barShouldHaveGaps == false and barwidth or barwidth - beautiful.barPadding
  alignlayout = wibox.layout.align.horizontal
  fixedlayout = wibox.layout.fixed.horizontal
end
local barMargin = beautiful.barShouldHaveGaps and beautiful.barPadding or 0
local function init(s)
  local wibar = awful.wibar {
    position = beautiful.barDir,
    height = barheight,
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
                margins = (beautiful.barDir == "top" or "bottom") and 8 or dpi(13),
              },
              widget = wibox.container.place
            },
            bg = beautiful.bg2,
            widget = wibox.container.background
          },
          layoutbox,
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
