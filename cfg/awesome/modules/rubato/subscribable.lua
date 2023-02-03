-- Kidna copying awesotre's stores on a surface level for added compatibility
local function subscribable(base)
	local obj = base or {}
	
	obj._subscribed = {}

	-- Subscrubes a function to the object so that it's called when `fire` is
	-- Calls subscribe_callback if it exists as well
	function obj:subscribe(func)
		local id = tostring(func):gsub("function: ", "")
		self._subscribed[id] = func

		if self.subscribe_callback then self.subscribe_callback(func) end
	end

	-- Unsubscribes a function and calls unsubscribe_callback if it exists
	function obj:unsubscribe(func)
		if not func then
			self._subscribed = {}
		else
			local id = tostring(func):gsub("function: ", "")
			self._subscribed[id] = nil
		end

		if self.unsubscribe_callback then self.unsubscribe_callback(func) end
	end

	function obj:fire(...) for _, func in pairs(self._subscribed) do func(...) end end

	return obj
end

return subscribable
