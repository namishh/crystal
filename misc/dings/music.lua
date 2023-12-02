local naughty = require("naughty")
local bling = require("mods.playerctl")
local playerctl = bling.lib()

playerctl:connect_signal("metadata",
  function(_, title, artist, album_path, album, new, player_name)
    if new == true then
      naughty.notify({ title = 'New Song', text = title .. " by " .. artist, image = album_path })
    end
  end)
