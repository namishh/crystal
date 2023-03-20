local awful = require('awful')
local gears = require('gears')

local function padding_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'cat /tmp/barPadding'", function(stdout)
      stdout = stdout:gsub("%s+", "")
      awesome.emit_signal('signal::padding', tonumber(stdout)) -- integer
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
    padding_emit()
  end
}
