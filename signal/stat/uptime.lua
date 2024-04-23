local awful = require('awful')
local gears = require('gears')
local function emit_uptime_status()
  awful.spawn.easy_async_with_shell(
    "bash -c \"uptime --pretty | sed 's/up\\s*//g' | sed 's/\\s*days/d/g' | sed 's/\\s*hours/h/g' | sed 's/\\s*minutes/m/g'\""
    ,
    function(stdout)
      stdout = stdout:gsub("%s+", "")
      awesome.emit_signal('signal::uptime', stdout)
    end)
end

gears.timer {
  timeout   = 60,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_uptime_status()
  end
}
