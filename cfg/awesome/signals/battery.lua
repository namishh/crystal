local awful = require('awful')
local gears = require('gears')
local gfs   = gears.filesystem

-- Battery Fetching and Signal Emitting
---------------------------------------
-- Battery information script
local battery_script = "bash -c 'echo $(cat /sys/class/power_supply/BAT0/capacity) echo $(cat /sys/class/power_supply/BAT0/status)'"

-- Emit a battery level signal
local level_old = -1
local power_old = -1
local function battery_emit()
  awful.spawn.easy_async_with_shell(
    battery_script, function(stdout)
    -- The battery level and status are saved as a string. Then the level
    -- is stored separately as a string, then converted to int. The status
    -- is stored as a bool, and also as an int for registering changes in
    -- battery status.
    local level     = string.match(stdout:match('(%d+)'), '(%d+)')
    local level_int = tonumber(level) -- integer
    local power     = not stdout:match('Discharging') -- boolean
    local power_int = power and 1 or 0 -- integer
    if level_int ~= level_old or power_int ~= power_old then
      awesome.emit_signal('signal::battery', level_int, power)
      power_old = power_int
      level_old = level_int
    end
  end)
end

-- Refreshing
-------------
gears.timer {
  timeout   = 20,
  call_now  = true,
  autostart = true,
  callback  = function()
    battery_emit()
  end
}
