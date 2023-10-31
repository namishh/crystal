local awful = require "awful"
local wibox = require "wibox"
local gears = require "gears"

local apps = require "main.apps"

mainmenu = awful.menu {
	items = {
		{ "Refresh", awesome.restart }, 
		{ "Terminal", apps.terminal },
		{ "Browser", apps.browser },
		{ "File Manager", apps.fileManager },
	}
}
