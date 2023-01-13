local awful = require('awful')
local gears = require('gears')

local brightness_script = "bash -c 'echo $(($(cat /sys/class/backlight/*/brightness) * 100 / $(cat /sys/class/backlight/*/max_brightness)))'"

local level_old = -1
local function emit_brightness()
  awful.spawn.easy_async_with_shell(
    brightness_script, function(stdout)
    local level_cur = tonumber(stdout)
    if level_cur ~= level_old then
      awesome.emit_signal('signal::brightness', level_cur)
      level_old = level_cur
    end
  end)
end

-- Refreshing
-------------
gears.timer {
  timeout   = 1,
  call_now  = true,
  autostart = true,
  callback  = function()
    emit_brightness()
  end
}
