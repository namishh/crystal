local awful = require "awful"

local volume = require "lib.volume"
local brightness = require "lib.brightness"

-- Volume
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86AudioRaiseVolume", function() volume.increase() end),
  awful.key({}, "XF86AudioLowerVolume", function() volume.decrease() end),
  awful.key({}, "XF86AudioMute", function() volume.mute() end)
})

-- Brightness
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86MonBrightnessUp", function() brightness.increase() end),
  awful.key({}, "XF86MonBrightnessDown", function() brightness.decrease() end),
  awful.key({ modkey, }, "a",
    function(c)
      awesome.emit_signal("toggle::launcher")
    end),
  awful.key({ modkey, }, "x",
    function(c)
      awesome.emit_signal("toggle::exit")
    end),
})
