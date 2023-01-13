local awful = require('awful')
local gears = require('gears')
local function emit_picom_status()
  awful.spawn.easy_async_with_shell(
    "bash -c 'pidof picom'", function(stdout)
    stdout = stdout:gsub("%s+", "")
    if stdout == "" then
      awesome.emit_signal('signal::picom', false)
    else
      awesome.emit_signal('signal::picom', true)
    end

  end)
end

gears.timer {
  timeout   = 2,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_picom_status()
  end
}
