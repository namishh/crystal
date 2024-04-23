local awful     = require('awful')
local gears     = require('gears')
local beautiful = require('beautiful')
local wibox     = require('wibox')

local widgets   = require('ui')

--- Attach tags and widgets to all screens.
screen.connect_signal('request::desktop_decoration', function(s)
  -- Create all tags and attach the layouts to each of them.
  awful.tag(require('config.user').tags, s, awful.layout.layouts[1])
  -- Attach a wibar to each screen.
  widgets.wibar(s)
end)

gears.wallpaper.maximized(beautiful.wallpaper)
