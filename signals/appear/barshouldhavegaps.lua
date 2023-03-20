local awful = require('awful')
local gears = require('gears')

local function bargap_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'cat /tmp/barGap'", function(value)
      local stringtoboolean = { ["true"] = true,["false"] = false }
      value = value:gsub("%s+", "")
      value = stringtoboolean[value]
      awesome.emit_signal('signal::bargap', value) -- integer
    end)
end

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    bargap_emit()
  end
}
