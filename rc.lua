local awful = require "awful"
local gears = require "gears"
local beautiful = require "beautiful"

beautiful.init(gears.filesystem.get_configuration_dir() .. "theme/init.lua")

require "main"
require "awful.autofocus"

-- init widget
require "misc"
require "ui"
require "lib"

-- Autorun at startup
awful.spawn.with_shell("bash ~/.config/awesome/main/autorun.sh")
