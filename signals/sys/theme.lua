local awful = require('awful')
local gears = require('gears')

local function theme_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'cat /tmp/themeName'", function(stdout)
      stdout = stdout:gsub("%s+", "")
      awesome.emit_signal('signal::theme', stdout) -- integer
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
    theme_emit()
  end
}
