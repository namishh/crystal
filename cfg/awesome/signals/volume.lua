local awful = require('awful')
local gears = require('gears')

-- Volume Fetching and Signal Emitting
--------------------------------------
-- Emit a volume level signal
local volume_old = -1
local function volume_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'pamixer --get-volume'", function(stdout)
    local volume_int = tonumber(stdout) -- integer
    if volume_int ~= volume_old then
      awesome.emit_signal('signal::volume', volume_int) -- integer
      volume_old = volume_int
    end
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
