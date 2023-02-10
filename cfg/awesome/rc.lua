-- awesome_mode: api-level=4:screen=on
local awful = require('awful')
-- load luarocks if installed
pcall(require, 'luarocks.loader')

-- load theme
local beautiful = require 'beautiful'
beautiful.init('~/.config/awesome/theme/init.lua')

require "modules.icon_customizer" { delay = 0 }

-- load key and mouse bindings
require 'bindings'

-- load rules
require 'rules'
-- load signals
require 'signals'

require 'ui'

require 'misc.bling'
awful.spawn.with_shell('~/.awesome/autostart.sh')
