local awful = require "awful"

local volume = require "lib.volume"
local brightness = require "lib.brightness"

-- Volume
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86AudioRaiseVolume", function()
    volume.increase()
    awesome.emit_signal("open::osd")
  end),
  awful.key({}, "XF86AudioLowerVolume", function()
    volume.decrease()
    awesome.emit_signal("open::osd")
  end),
  awful.key({}, "XF86AudioMute", function()
    volume.mute()
    awesome.emit_signal("open::osd")
  end)
})

-- Brightness
awful.keyboard.append_global_keybindings({
  awful.key({}, "XF86MonBrightnessUp", function()
    brightness.increase()
    awesome.emit_signal("open::osdb")
  end),

  awful.key({}, "XF86MonBrightnessDown", function()
    brightness.decrease()
    awesome.emit_signal("open::osdb")
  end),
  awful.key({ modkey, }, "a",
    function(c)
      awesome.emit_signal("toggle::launcher")
    end),
  awful.key({ modkey, }, "x",
    function(c)
      awesome.emit_signal("toggle::exit")
    end),
  awful.key({ modkey, }, "q",
    function(c)
      awesome.emit_signal("toggle::scrotter")
    end),
})
