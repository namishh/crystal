local awful = require('awful')
local gears = require('gears')
local naughty = require("naughty")
-- Network Fetching and Signal Emitting
---------------------------------------
local status_old = -1
local function emit_airplane_status()
  awful.spawn.easy_async_with_shell(
    "bash -c \"rfkill list | sed -n 2p | awk '{print $3}'\" ", function(stdout)
    local status    = stdout:match("yes") -- boolean
    local status_id = status and 1 or 0 -- integer
    if status_id ~= status_old then
      awesome.emit_signal('signal::airplane', status)
      status_old = status_id
    end
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
