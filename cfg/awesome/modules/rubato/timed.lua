if not RUBATO_DIR then RUBATO_DIR = (...):match("(.-)[^%.]+$") end
if not RUBATO_MANAGER then RUBATO_MANAGER = require(RUBATO_DIR.."manager") end

local subscribable = require(RUBATO_DIR.."subscribable")
local glib = require("lgi").GLib

--- Get the slope (this took me forever to find).
-- i is intro duration
-- o is outro duration
-- t is total duration
-- d is distance to cover
-- F_1 is the value of the antiderivate at 1: F_1(1)
-- F_2 is the value of the outro antiderivative at 1: F_2(1)
-- b is the y-intercept
-- m is the slope
-- @see timed
local function get_slope(i, o, t, d, F_1, F_2, b)
	return (d + i * b * (F_1 - 1)) / (i * (F_1 - 1) + o * (F_2 - 1) + t)
end

--- Get the dx based off of a bunch of factors
-- @see timed
local function get_dx(time, duration, intro, intro_e, outro, outro_e, m, b)
	-- Intro math. Scales by difference between initial slope and target slope
	if time <= intro then
		return intro_e(time / intro) * (m - b) + b

	-- Outro math
	elseif (duration - time) <= outro then
		return outro_e((duration - time) / outro) * m

	-- Otherwise (it's in the plateau)
	else return m end
end

--weak table for memoizing results
local simulate_easing_mem = {}
setmetatable(simulate_easing_mem, {__mode="kv"})

--- Simulates the easing to get the result to find an error coefficient
-- Uses the coefficient to adjust dx so that it's guaranteed to hit the target
-- This must be called when the sign of the target slope is changing
-- @see timed
local function simulate_easing(pos, duration, intro, intro_e, outro, outro_e, m, b, dt)
	local ps_time = 0
	local ps_pos = pos
	local dx
	print("simulating")


	-- Key for cacheing results
	local key = string.format("%f %f %f %s %f %s %f %f",
		pos, duration,
		intro, tostring(intro_e),
		outro, tostring(outro_e),
		m, b)

	-- Short circuits if it's already done the calculation
	if simulate_easing_mem[key] then return simulate_easing_mem[key] end

	-- Effectively runs the exact same  code to find what the target will be
	while duration - ps_time >= dt / 2 do
		--increment time
		ps_time = ps_time + dt

		--get dx, but use the pseudotime as to not mess with stuff
		dx = get_dx(ps_time, duration,
			intro, intro_e,
			outro, outro_e,
			m, b)

		--increment pos by dx
		ps_pos = ps_pos + dx * dt
	end

	simulate_easing_mem[key] = ps_pos
	return ps_pos
end

--- Preprocess position
-- do any preprocessing of position necessary
-- currently just handles clamp_position but should be flexible
local function preprocess_pos(obj)
	local pos = obj.pos
	if (obj.clamp_position) then pos = (obj._m < 0 and math.max or math.min)(obj.pos, obj.target) end
	return pos
end

--RUBATO_TIMEOUTS contains multiple timeouts for different rates
--function creates timers which run in the background handling animations at distinct rates
--this allows for rates to change dynamiclally during runtime should you wanna set everything's
--rate to like 2fps for some reason or if you wanna switch from 144Hz to 60Hz or something
--first index is normal timeouts, second index is override_dt timeouts
if not RUBATO_TIMEOUTS then RUBATO_TIMEOUTS = {{}, {}} end

--create_timeout is called whenever a timer tries to start an animation and there's not a timeout
--with the correct rate already in RUBATO_TIMEOUTS
local function create_timeout(rate, override_dt)
	local time_last = glib.get_monotonic_time()
	local initial_dt = 1 / rate
	return glib.timeout_add(glib.PRIORITY_DEFAULT, initial_dt * 1000, function()

	local dt = initial_dt
	if not override_dt then
		local time = (glib.get_monotonic_time() - time_last) / 1000000
		if time >= initial_dt * 1.05 then dt = time end --give it 5% moe
	end

	for _, obj in pairs(RUBATO_MANAGER.timeds) do

		if obj.rate == rate and obj.override_dt == override_dt and obj._time ~= obj.duration and not obj.pause then

			--increment time
			obj._time = obj._time + dt

			--get dx
			obj._dx = get_dx(obj._time, obj.duration,
				(obj._is_inter and obj.inter or obj.intro) * (obj.prop_intro and obj.duration or 1),
				obj._is_inter and obj.easing_inter.easing or obj.easing.easing,
				obj.outro * (obj.prop_intro and obj.duration or 1),
				obj.easing_outro.easing,
				obj._m, obj._b)

			--increment pos by dx
			--scale by dt and correct with coef if necessary
			obj.pos = obj.pos + obj._dx * dt * obj._coef

			--sets up when to stop by time
			--weirdness is to try to get as close to duration as possible
			if obj.duration - obj._time < dt / 2 --[[or obj.is_instant]] then
				obj.pos = obj._props.target --snaps to target in case of small error
				obj._time = obj.duration --snaps time to duration

				obj._is_inter = false --resets intermittent

				--run subscribed in functions
				--snap time to duration at end
				obj:fire(preprocess_pos(obj), obj.duration, obj._dx)

				-- awestore compatibility
				if obj.awestore_compat then obj.ended:fire(obj.pos, obj.duration, obj._dx) end

			--otherwise it just fires normally
			else obj:fire(preprocess_pos(obj), obj._time, obj._dx) end

		end
	end
	time_last = glib.get_monotonic_time()
	return true
end) end

--- INTERPOLATE. bam. it still ends in a period. But this one is timed.
-- So documentation isn't super necessary here since it's all on the README and idk how to do
-- documentation correctly, so please see the README or read the code to better understand how
-- it works
local function timed(args)

	local obj = subscribable()

	function obj:reset_values()
		--set up default arguments
		self.duration = args.duration or RUBATO_MANAGER.timed.defaults.duration
		self.pos = args.pos or RUBATO_MANAGER.timed.defaults.pos

		self.prop_intro = args.prop_intro or RUBATO_MANAGER.timed.defaults.prop_intro

		self.intro = args.intro or (RUBATO_MANAGER.timed.defaults.intro > self.duration * 0.5 and self.duration * 0.5 or RUBATO_MANAGER.timed.defaults.intro)
		self.inter = args.inter or args.intro

		--set args.outro nicely based off how large args.intro is
		if self.intro > (self.prop_intro and 0.5 or self.duration) and not args.outro then
			self.outro = math.max((self.prop_intro and 1 or self.duration - self.intro), 0)

		elseif not args.outro then self.outro = self.intro
		else self.outro = args.outro end

		--assert that these values are valid
		--deal with 0.1+0.2!=0.3 somehow??
		assert(self.intro + self.outro <= self.duration or self.prop_intro, "Intro and Outro must be less than or equal to total duration")
		assert(self.intro + self.outro <= 1 or not self.prop_intro, "Proportional Intro and Outro must be less than or equal to 1")

		self.easing = args.easing or RUBATO_MANAGER.timed.defaults.easing
		self.easing_outro = args.easing_outro or self.easing
		self.easing_inter = args.easing_inter or self.easing

		--dev interface changes
		self.log = args.log or RUBATO_MANAGER.timed.defaults.log
		self.debug = args.debug
		self.awestore_compat = args.awestore_compat or RUBATO_MANAGER.timed.defaults.awestore_compat

		--animation logic changes
		self.override_simulate = args.override_simulate or RUBATO_MANAGER.timed.defaults.override_simulate
		self.rapid_set = args.rapid_set == nil and self.awestore_compat or args.rapid_set
		self.clamp_position = args.clamp_position or RUBATO_MANAGER.timed.defaults.clamp_position
		self.is_instant = args.is_instant

		-- hidden properties
		self._props = {
			target = self.pos,
			rate = args.rate or RUBATO_MANAGER.timed.defaults.rate,
			override_dt = args.override_dt or RUBATO_MANAGER.timed.defaults.override_dt
		}

	end
	obj:reset_values()

	-- awestore compatibility
	if obj.awestore_compat then
		obj._initial = obj.pos
		obj._last = 0

		function obj:initial() return obj._initial end
		function obj:last() return obj._last end

		obj.started = subscribable()
		obj.ended = subscribable()

	end

	-- Variables used in calculation, defined once bcz less operations
	obj._time = 0				  -- current time
	obj._dt = 1 / obj._props.rate -- change in time
	obj._dt_index = obj._props.override_dt and 2 or 1 --index in RUBATO_TIMEOUTS
	obj._dx = 0 				  -- value of slope at current time
	obj._m = 0					  -- slope
	obj._b = 0					  -- y-intercept
	obj._is_inter = false		  --whether or not it's in an intermittent state

	-- Variables used in simulation
	obj._ps_pos = 0	-- pseudoposition
	obj._coef = 1	-- corrective coefficient TODO: apply to plateau

	-- Set target and begin interpolation
	local function set(value)

		--if it's instant just do it lol, no need to go through all this
		if obj.is_instant then obj:fire(preproceesvalue, obj.duration, obj.pos - value); return end

		--disallow setting it twice (because it makes it go wonky sometimes)
		if not obj.rapid_set and obj._props.target == value then return end

		--animation values
		obj._time = 0 --resets time
		obj._coef = 1 --resets coefficient

		--ensure that timer for specific rate exists, then set it
		if not RUBATO_TIMEOUTS[obj._dt_index][obj.rate] then RUBATO_TIMEOUTS[obj._dt_index][obj.rate] = create_timeout(obj.rate, obj.override_dt) end
		obj._dt = 1 / obj.rate

		--does awestore compatibility
		if obj.awestore_compat then
			obj._last = value
			obj.started:fire(obj.pos, obj._time, obj._dx)
		end

		-- if the animation is in motion (pos != target) reflect that in is_inter
		obj._is_inter = obj.pos ~= obj._props.target

		--set initial position if interrupting another animation
		obj._b = obj._is_inter and obj._dx or 0

		--get the slope of the plateau
		obj._m = get_slope((obj._is_inter and obj.inter or obj.intro) * (obj.prop_intro and obj.duration or 1),
			obj.outro * (obj.prop_intro and obj.duration or 1),
			obj.duration,
			value - obj.pos,
			obj._is_inter and obj.easing_inter.F or obj.easing.F,
			obj.easing_outro.F,
			obj._b)

		--if it will make a mistake (or override_simulate is true), fix it
		--it should only make a mistake when switching direction
		--b ~= zero protection so that I won't get any NaNs (because NaN ~= NaN)
		if obj.override_simulate or (obj._b ~= 0 and obj._b / math.abs(obj._b) ~= obj._m / math.abs(obj._m)) then
			obj._ps_pos = simulate_easing(obj.pos, obj.duration,
				(obj._is_inter and obj.inter or obj.intro) * (obj.prop_intro and obj.duration or 1),
				obj._is_inter and obj.easing_inter.easing or obj.easing.easing,
				obj.outro * (obj.prop_intro and obj.duration or 1),
				obj.easing_outro.easing,
				obj._m, obj._b, obj._dt)

			--get coefficient by calculating ratio of theoretical range : experimental range
			obj._coef = (obj.pos - value) / (obj.pos - obj._ps_pos)
			if obj._coef ~= obj._coef then obj._coef = 1 end --check for div by 0 resulting in NaN
		end

		--set target, triggering timeout since pos != target
		obj._props.target = value --sets target

		--finally, fire it once with initial values
		obj:fire(obj.pos, obj._time, obj._dx)

	end

	if obj.awestore_compat then function obj:set(target) set(target) end end

	-- Functions for setting state
	-- Completely resets the timer
	-- this is more like an "abort" than a "reset" since I don't keep track of intiial position
	function obj:abort()
		obj._time = 0
		obj._props.target = obj.pos
		obj._dx = 0
		obj._m = nil
		obj._b = nil
		obj._is_inter = false
		obj._coef = 1
		obj._dt = 1 / obj.rate
		obj:fire(obj.pos, obj.time, obj._dx) --fire once to reset visually too
	end

	--override to allow calling fire with no arguments
	local unpack = unpack or table.unpack
	function obj:fire(...) args = ({...})[1] and {...} or {obj.pos, obj._time, obj._dx}; for _, func in pairs(obj._subscribed) do func(unpack(args)) end end

	--subscribe stuff initially and add callback
	obj.subscribe_callback = function(func) func(obj.pos, obj._time, obj._dt) end
	if args.subscribed ~= nil then obj:subscribe(args.subscribed) end

	-- Metatable for cooler api
	local mt = {}
	function mt:__index(key)
		-- Returns the state value
		if key == "running" then
			if obj.pause then return false
			else return obj._props.target ~= obj.pos end

		-- If it's in _props return it from props
		elseif self._props[key] then return self._props[key]

		-- Otherwise just be nice
		else return rawget(self, key) end
	end
	function mt:__newindex(key, value)
		-- Don't allow for setting state
		if key == "running" then return

		-- Changing target should call set
		elseif key == "target" then set(value) --set target

		-- Changing rate should also update dt
		elseif key == "rate" then
			self._props.rate = value
			self._dt = 1 / value

		-- Changing override_dt should also update dt_state
		elseif  key == "override_dt" then
			self._props.override_dt = value
			self._dt_index = self._props.override_dt and 2 or 1
		-- If it's in _props set it there
		elseif self._props[key] ~= nil then self._props[key] = value

		-- Otherwise just set it normally
		else rawset(self, key, value) end
	end

	setmetatable(obj, mt)

	table.insert(RUBATO_MANAGER.timeds, obj)
	return obj

end

return timed
