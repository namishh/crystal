local awful = require("awful")
local gobject = require("gears.object")
local gtable = require("gears.table")

local brightness = {}
function brightness:increase_brightness(step)
  awful.spawn("brightnessctl s +" .. step .. "%", false)
end

function brightness:decrease_brightness(step)
  awful.spawn("brightnessctl s " .. step .. "%-", false)
end

function brightness:set_brightness(step)
  awful.spawn("brightnessctl s " .. step .. "%", false)
end

local function get_brightness(self)
  awful.spawn.easy_async("brightnessctl g", function(value)
    awful.spawn.easy_async("brightnessctl m", function(max)
      local percentage = tonumber(value) / tonumber(max) * 100
      self:emit_signal("update", percentage)
    end)
  end)
end

local function new()
  local ret = gobject {}
  gtable.crush(ret, brightness, true)

  get_brightness(ret)
  awful.spawn.easy_async_with_shell(
    "ps x | grep \"inotifywait -e modify /sys/class/backlight\" | awk '{print $1}' | xargs kill",
    function()
      -- Update brightness status with each line printed
      awful.spawn.with_line_callback(
        'bash -c "while (inotifywait -e modify /sys/class/backlight/?**/brightness -qq) do echo; done"',
        {
          stdout = function(_)
            get_brightness(ret)
          end,
        }
      )
    end)
  return ret
end

return new()
