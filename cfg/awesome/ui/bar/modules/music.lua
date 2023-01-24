local beautiful = require("beautiful")
local awful     = require("awful")
local helpers   = require("helpers")
local wibox     = require("wibox")
local dpi       = require("beautiful").xresources.apply_dpi
local bling     = require("modules.bling")

local playerctl = bling.signal.playerctl.cli()

local songname = wibox.widget {
  font = beautiful.font,
  markup = " None ",
  valign = "center",
  align = "center",
  widget = wibox.widget.textbox,
}

local songnamebox = wibox.widget {
  songname,
  width = dpi(100),
  widget = wibox.container.constraint

}
local play_button = wibox.widget {
  buttons = {
    awful.button({}, 1, function()
      awesome.emit_signal('song::toggle')
    end)
  },
  image = beautiful.play,
  widget = wibox.widget.imagebox
}

local toggle = wibox.widget {
  play_button,
  margins = 4,
  widget = wibox.container.margin
}

local music_control = wibox.widget {
  songnamebox,
  toggle,
  spacing = 10,
  layout = wibox.layout.fixed.horizontal,
}

local widget = wibox.widget {
  {
    {
      music_control,
      layout = wibox.layout.fixed.horizontal,
    },
    margins = 6,
    widget = wibox.container.margin,
  },
  bg = beautiful.bg2 .. 'cc',
  widget = wibox.container.background,
}

playerctl:connect_signal("playback_status", function(_, playing, _)
  if playing then
    play_button.image = beautiful.pause
  else
    play_button.image = beautiful.play
  end
end)

playerctl:connect_signal("metadata", function(_, title)
  if title == "" then
    title = " None "
  end

  songname:set_markup_silently(" " .. title .. " ")
end)

awesome.connect_signal("song::toggle", function()
  playerctl:play_pause()
end)


return widget
