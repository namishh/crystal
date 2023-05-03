local awful = require 'awful'
local beautiful = require 'beautiful'
local gears = require 'gears'
local vars = require 'config.vars'
screen.connect_signal('request::desktop_decoration', function(s)
  gears.wallpaper.maximized(beautiful.wall, s, beautiful.mbg)
  awful.tag(vars.tags, s, awful.layout.layouts[1])
end)
