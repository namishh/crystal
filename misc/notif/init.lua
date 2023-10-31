local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears" 
local beautiful = require "beautiful"
local ruled = require "ruled"
local naughty = require "naughty"
local dpi = beautiful.xresources.apply_dpi

ruled.notification.connect_signal('request::rules', function()
    ruled.notification.append_rule {
        rule       = { },
        properties = {
            screen           = awful.screen.preferred,
            implicit_timeout = 5,
        }
    }
end)

naughty.connect_signal("request::display", function(n)
    naughty.layout.box { notification = n }
end)


