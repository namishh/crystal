local awful = require('awful')
local gears = require('gears')

-- Network Fetching and Signal Emitting
---------------------------------------
local function emit_network_status()
  awful.spawn.easy_async_with_shell(
    "bash -c 'nmcli networking connectivity check'", function(stdout)
      local status = not stdout:match("none") -- boolean
      awesome.emit_signal('signal::network', status)
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
