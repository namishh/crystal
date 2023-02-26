local wibox     = require 'wibox'
local gears     = require 'gears'
local beautiful = require("beautiful")
local ruled     = require("ruled")
local bling     = require("modules.bling")
local helpers   = require("helpers")
local playerctl = bling.signal.playerctl.lib()
local dpi       = beautiful.xresources.apply_dpi

local art       = wibox.widget {
  image                  = beautiful.songdefpicture,
  clip_shape             = helpers.rrect(10),
  vertical_fill_policy   = "fit",
  horizontal_fill_policy = "fit",
  resize                 = true,
  valign                 = 'center',
  opacity                = 0.16,
  widget                 = wibox.widget.imagebox
}


local finalwidget = wibox.widget {
  art,
  layout = wibox.layout.stack
}
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
  -- Set art widget
  if title == "" then
    title = "None"
  end
  if artist == "" then
    artist = "Unknown"
  end
  art.image = helpers.cropSurface(2, gears.surface.load_uncached(album_path))
end)

return finalwidget
