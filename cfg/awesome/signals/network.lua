local awful = require('awful')
local gears = require('gears')

-- Network Fetching and Signal Emitting
---------------------------------------
local status_old = -1
local function emit_network_status()
  awful.spawn.easy_async_with_shell(
    "bash -c 'nmcli networking connectivity check'", function(stdout)
    local status    = not stdout:match("none") -- boolean
    local status_id = status and 1 or 0 -- integer
    if status_id ~= status_old then
      awesome.emit_signal('signal::network', status)
      status_old = status_id
    end
  end)
end

-- Refreshing
-------------
gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_network_status()
  end
}
