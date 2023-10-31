local awful = require "awful"

local volume = {}

volume.increase = function()
	local script = [[
	pamixer -i 3
	]]

	awful.spawn.with_shell(script)
end

volume.decrease = function()
	local script = [[
	pamixer -d 3
	]]

	awful.spawn.with_shell(script)
end

volume.mute = function()
	local script = [[
	pamixer -t
	]]

	awful.spawn.with_shell(script)
end

return volume
