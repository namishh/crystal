if not RUBATO_DIR then RUBATO_DIR = (...):match("(.-)[^%.]+$").."rubato." end
if not RUBATO_MANAGER then RUBATO_MANAGER = require(RUBATO_DIR.."manager") end

return {
	--depreciated
	set_def_rate = function(rate) RUBATO_MANAGER.timed.defaults.rate = rate end,
	set_override_dt = function(value) RUBATO_MANAGER.timed.defaults.override_dt = value end,

	--Modules
	timed = require(RUBATO_DIR.."timed"),
	easing = require(RUBATO_DIR.."easing"),
	subscribable = require(RUBATO_DIR.."subscribable"),
	manager = RUBATO_MANAGER,
}
