local awful = require('awful')
local gears = require('gears')

local function light_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'cat ~/.cache/redshift'", function(stdout)
      local status = stdout:match("true") -- boolean
      awesome.emit_signal('signal::redshift', status)
    end)
end

-- Microphone Fetching and Signal Emitting
-- Refreshing
-------------
gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    light_emit()
  end
}
