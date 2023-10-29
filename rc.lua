local gtimer = require "gears.timer"
require 'beautiful'.init('~/.config/awesome/theme/init.lua')
require 'signals'
require 'main'
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
