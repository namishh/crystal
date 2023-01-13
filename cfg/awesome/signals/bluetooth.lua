local awful = require('awful')
local gears = require('gears')

-- Bluetooth Fetching and Signal Emitting
-----------------------------------------
local status_old = -1
local function emit_bluetooth_status()
  awful.spawn.easy_async_with_shell(
    "bash -c 'bluetoothctl show | grep -i powered:'", function(stdout)
    local status    = stdout:match("yes") -- boolean
    local status_id = status and 1 or 0 -- integer
    if status_id ~= status_old then
      awesome.emit_signal('signal::bluetooth', status)
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
    emit_bluetooth_status()
  end
}
