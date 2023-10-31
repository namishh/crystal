local awful = require "awful"

local brightness = {}

brightness.increase = function()
	local script = [[
	brightnessctl set 3%+
	]]

	awful.spawn.with_shell(script)
end

brightness.decrease = function()
	local script = [[
	brightnessctl set 3%-
	]]

	awful.spawn.with_shell(script)
end

return brightness
