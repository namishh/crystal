local gears = require "gears"
local beautiful = require "beautiful"
local helpeers = require "helpers"


local function set_wall(s)
  local d = helpeers.readJson(gears.filesystem.get_cache_dir() .. 'json/settings.json')
  if d.wallpaper == "colorful" then
    gears.wallpaper.maximized(beautiful.wallpaper, s, beautiful.mbg)
  else
    gears.wallpaper.set(beautiful.bg3)
  end
end

screen.connect_signal("request::wallpaper", function(s)
  set_wall(s)
end)
