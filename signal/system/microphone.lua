local awful = require('awful')
local gears = require('gears')

local function mic_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c 'pamixer --source 1 --get-mute'", function(value)
      local stringtoboolean = { ["true"] = false, ["false"] = true }
      value = value:gsub("%s+", "")
      value = stringtoboolean[value]
      awesome.emit_signal('signal::mic', value) -- integer
    end)
end

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    mic_emit()
  end
}
