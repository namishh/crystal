local awful = require('awful')
local gears = require('gears')
local function emit_cpu_status()
  awful.spawn.easy_async_with_shell(
    "bash -c \"roundvalue $(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}')\""
    ,
    function(stdout)
      stdout = tonumber(stdout)
      awesome.emit_signal('signal::cpu', stdout)
    end)
end

gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_cpu_status()
  end
}
