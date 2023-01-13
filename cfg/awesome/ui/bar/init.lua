local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi

-- Importing all the compoments
local systraybox = require("ui.bar.modules.systray")
local layoutbox = require("ui.bar.modules.layout")
local taglist = require("ui.bar.modules.tags")
local tasklist = require("ui.bar.modules.tasklist")
local status = require("ui.bar.modules.status")
local time = require("ui.bar.modules.time")
local music = require("ui.bar.modules.music")
local launcher = require("ui.bar.modules.misc").launcher
local powerbutton = require("ui.bar.modules.misc").powerbutton

local function init(s)
  local wibar = awful.wibar {
    position = "bottom",
    height = dpi(50),
    bg = beautiful.bg,
    fg = beautiful.fg1,
    screen = s,
    widget = {
      layout = wibox.layout.align.horizontal,
      {
        -- Left
        {
          layout = wibox.layout.fixed.horizontal,
          launcher,
          taglist(s),
          layoutbox,
          spacing = 7,
        },
        top = dpi(8),
        bottom = dpi(5),
        right = dpi(7),
        left = dpi(7),
        widget = wibox.container.margin
      },
      {
        -- Middle
        { tasklist(s),
          halign = 'left',
          layout = wibox.container.place,
        },
        top = dpi(8),
        bottom = dpi(6),
        widget = wibox.container.margin
      },
      {
        --Right
        {
          systraybox,
          status,
          music,
          time,
          powerbutton,
          spacing = 7,
          layout = wibox.layout.fixed.horizontal,
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
