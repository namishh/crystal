local awful = require('awful')
local gears = require('gears')
local function emit_redshift_status()
  awful.spawn.easy_async_with_shell(
    "bash -c 'pidof redshift'", function(stdout)
    stdout = stdout:gsub("%s+", "")
    if stdout == "" then
      awesome.emit_signal('signal::night', false)
    else
      awesome.emit_signal('signal::night', true)
    end

  end)
end

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_redshift_status()
  end
}
