local gears = require('gears')
local naughty = require("naughty")
-- Network Fetching and Signal Emitting
---------------------------------------
local function emit_dnd_status()
  local status = naughty.is_suspended()
  awesome.emit_signal('signal::dnd', status)
end

-- Refreshing
-------------
gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_dnd_status()
  end
}
