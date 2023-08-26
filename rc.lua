local gtimer = require "gears.timer"
require 'beautiful'.init('~/.config/awesome/theme/init.lua')
require 'main'
require 'signals'
require 'ui'


gtimer {
  timeout = 5,
  autostart = true,
  call_now = true,
  callback = function()
    collectgarbage "collect"
  end,
}

collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)
