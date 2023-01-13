local awful = require 'awful'
local beautiful = require 'beautiful'
local wibox = require 'wibox'
local vars = require 'config.vars'


screen.connect_signal('request::desktop_decoration', function(s)
  awful.tag(vars.tags, s, awful.layout.layouts[1])
end)
