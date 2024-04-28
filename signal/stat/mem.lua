local awful = require('awful')
local gears = require('gears')
local function emit_mem_status()
  awful.spawn.easy_async_with_shell(
    "bash -c \"roundvalue $(free | grep Mem | awk '{print $3/$2 * 100.0}')\""
    ,
    function(stdout)
      stdout = tonumber(stdout)
      awesome.emit_signal('signal::memory', stdout)
    end)
end

gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_mem_status()
  end
}
