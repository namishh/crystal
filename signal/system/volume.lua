local awful = require('awful')
local gears = require('gears')

local function volume_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'pamixer --get-volume'", function(stdout)
      local volume_int = tonumber(stdout)             -- integer
      awesome.emit_signal('signal::volume', volume_int) -- integer
    end)
end

-- Microphone Fetching and Signal Emitting
-- Refreshing
-------------
gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    volume_emit()
  end
}
