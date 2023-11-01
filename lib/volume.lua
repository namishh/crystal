local awful = require "awful"

local volume = {}

volume.increase = function()
  local script = [[
	pamixer -i 3
	]]

  awful.spawn.with_shell(script)
  awesome.emit_signal("volume::notif")
end

volume.decrease = function()
  local script = [[
	pamixer -d 3
	]]

  awful.spawn.with_shell(script)
  awesome.emit_signal("volume::notif")
end

volume.mute = function()
  local script = [[
	pamixer -t
	]]

  awful.spawn.with_shell(script)
  awesome.emit_signal("volume::notif")
end

return volume
