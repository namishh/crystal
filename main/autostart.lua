local awful = require("awful")
require 'config.bling'
awful.spawn.with_shell('xrdb -merge ~/.Xresources')
awful.spawn.with_shell('mpDris2 &')
awful.spawn.with_shell('picom &')
awful.spawn.with_shell('sxhkd &')
awful.spawn.with_shell('udiskie &')
