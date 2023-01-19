local beautiful = require 'beautiful'
local bling     = require("modules.bling")
local awful     = require("awful")
local wibox     = require("wibox")
local terminal  = require 'config.apps'.terminal
local M         = {}


local createScratch = function(command, width, height)
  local scratch = bling.module.scratchpad {
    command = terminal .. ' -n "' .. command .. 'pad ' .. '" -e sh -c "' .. command .. '; $SHELL"',
    rule = { instance = command .. 'pad' },
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = { x = 360, y = 90, height = height, width = width },
    reapply = true,
  }
  awesome.connect_signal('toggle::' .. command .. 'pad', function()
    scratch:toggle()
  end)
  return scratch
end


M.scratchpads = {
  default = createScratch('pfetch', 900, 680),
  ncmp = createScratch('ncmpcpp', 680, 500)
}

awful.screen.connect_for_each_screen(function(s)
  --Tiled Wallpaper
   bling.module.tiled_wallpaper(" ", s, {
     bg = beautiful.pri .. "da",
     fg = beautiful.bg3,
     offset_y = 25,
     offset_x = 25,
     font = beautiful.icofont,
     font_size = 35,
     padding = 270,
     zickzack = true
   })
  -- Regular Wallpaper
  --bling.module.wallpaper.setup {
  --  wallpaper = beautiful.wall
  --}
end)

-- Start Window Swallowing
bling.module.window_swallowing.start()
return M
