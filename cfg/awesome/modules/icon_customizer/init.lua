local gears = require("gears")
local awful = require("awful")
local theme = require("beautiful")
local cairo = require("lgi").cairo

local module = {}

-- luacheck: globals client
local client = client

local icons, dynamic_icons, dynamic_classes, delay

local function len(T)
	local count = 0
	for _ in pairs(T) do
		count = count + 1
	end
	return count
end

local function contains(T, V)
	for _, v in ipairs(T) do
		if v == V then
			return true
		end
	end
	return false
end

local function icon_copy(icon)
	if not icon then
		return nil
	end
	local s = gears.surface(icon)
	local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
	local cr = cairo.Context(img)
	cr:set_source_surface(s, 0, 0)
	cr:paint()
	return img
end

local function set_icon(c, icon)
	if c and c.valid then
		if not c.icon_backup then
			c.icon_backup = icon_copy(icons[c.class]) or icon_copy(c.icon)
		end
		icon = icon_copy(icon)
		if icon then
			c.icon = icon._native
		end
	end
end

local function set_dynamic_icon(c)
	if c.name then
		for regex, icon in pairs(dynamic_icons) do
			if string.find(c.name, regex) then
				set_icon(c, icon)
				return
			end
		end
	end

	if c.icon_backup then
		c.icon = c.icon_backup._native or nil
	end
end

local function setup(config)
	local cfg = config or {}

	icons = cfg.icons or theme.ic_icons or {}
	dynamic_icons = cfg.dynamic_icons or theme.ic_dynamic_icons or {}
	dynamic_classes = cfg.dynamic_classes or theme.ic_dynamic_classes or {}
	delay = cfg.delay or 0.5
	local fallback_icon = cfg.fallback_icon or theme.ic_fallback_icon or nil

	if type(icons) ~= "table" then
		icons = {}
	end
	if type(dynamic_icons) ~= "table" then
		dynamic_icons = {}
	end
	if type(dynamic_classes) ~= "table" then
		dynamic_classes = {}
	end
	if type(delay) ~= "number" then
		delay = 0.5
	end

	client.connect_signal("manage", function(c)
		-- set icon based on c.class
		awful.spawn.easy_async_with_shell("sleep " .. delay, function()
			if c and c.valid then
				if icons[c.class] then
					set_icon(c, icons[c.class])
				elseif not c.icon and fallback_icon then
					set_icon(c, fallback_icon)
				end
				-- fix #2: Dynamic icons not working without changing the window name
				if contains(dynamic_classes, c.class) then
					set_dynamic_icon(c)
				end
			end
		end)

		if len(dynamic_icons) == 0 then
			-- user has not defined any dynamic_icons; exit
			return
		end

		-- dynamic classes are only being checked if defined explicitly by the user
		if len(dynamic_classes) > 0 then
			if not contains(dynamic_classes, c.class) then
				-- client is not in dynamic_classes; exit
				return
			end
		end

		-- the client name is now being monitored
		c:connect_signal("property::name", set_dynamic_icon)
	end)
end

return setmetatable(module, {
	__call = function(_, ...)
		setup(...)
		-- we have to update all clients icons manually when the user restarts awesomewm
		-- since there is no "property::name" signal emitted by already running clients.
		-- the set delay has to be higher than the regular delay, otherwise a race condition between both signals exists.
		awful.spawn.easy_async_with_shell("sleep " .. (delay + 0.5), function()
			for _, c in ipairs(client.get()) do
				if c and c.valid then
					c:emit_signal("property::name")
				end
			end
		end)
	end,
})
