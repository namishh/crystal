local awful = require('awful')

-- load theme
local beautiful = require 'beautiful'
beautiful.init('~/.config/awesome/theme/init.lua')
beautiful.setTheme()

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
