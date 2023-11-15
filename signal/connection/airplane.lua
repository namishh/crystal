local awful = require('awful')
local gears = require('gears')
local naughty = require("naughty")

local function emit_airplane_status()
  awful.spawn.easy_async_with_shell(
    "bash -c \"rfkill list | sed -n 2p | awk '{print $3}'\" ", function(stdout)
      local status = stdout:match("yes") -- boolean
      awesome.emit_signal('signal::airplane', status)
    end)
end

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_airplane_status()
  end
}
