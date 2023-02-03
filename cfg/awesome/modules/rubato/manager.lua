if not RUBATO_DIR then RUBATO_DIR = (...):match("(.-)[^%.]+$") end

local easing = require(RUBATO_DIR.."easing")

local function make_props_immutable(table)
	setmetatable(table, {
		__index = function(self, key)
			if self._props[key] then return self._props[key]
			else return rawget(self, key) end
		end,
		__newindex = function(self, key, value)
			if self._props[key] then return
			else self._props[key] = value end
		end,
	})
end

local function manager()
	local obj = {_props = {}}
	make_props_immutable(obj)

	obj._props.timeds = {}

	obj._props.timed = {_props = {}}
	obj._props.timed._props.defaults = {
		duration = 1,
		pos = 0,
		prop_intro = false,
		intro = 0.2,
		easing = easing.linear,
		awestore_compat = false,
		log = function() end,
		override_simulate = false,
		override_dt = false,
		clamp_position = false,
		rate = 60,
	}
	make_props_immutable(obj.timed)
	obj._props.timed._props.override = {_props = {
		clear = function() for _, timed in pairs(obj.timeds) do timed:reset_values() end end,
		forall = function(func) for _, timed in pairs(obj.timeds) do func(timed) end end,
	}}

	setmetatable(obj.timed.override, {
		__index = function(self, key) return self._props[key] end,
		__newindex = function(self, key, value)
			for _, timed in pairs(obj.timeds) do timed[key] = value end
			self._props[key] = value
		end
	})

	return obj
end

if not RUBATO_MANAGER then RUBATO_MANAGER = manager() end
return RUBATO_MANAGER
