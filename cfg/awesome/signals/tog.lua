local awful = require('awful')
local gears = require('gears')


local function tog_emit()
  awful.spawn.easy_async_with_shell(
    "bash -c '~/.config/awesome/scripts/toggle --stat'", function(value)
    local stringtoboolean = { ["true"] = true, ["false"] = false }
    value = value:gsub("%s+", "")
    value = stringtoboolean[value]

    -- awful.spawn.with_shell('notify-send ' .. tostring(value))
    awesome.emit_signal('signal::toggler', value) -- integer
  end)
end

gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    tog_emit()
  end
}
