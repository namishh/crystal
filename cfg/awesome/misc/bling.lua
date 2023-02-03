local beautiful = require 'beautiful'
local bling     = require("modules.bling")
local awful     = require("awful")
local wibox     = require("wibox")
local terminal  = require 'config.apps'.terminal
local M         = {}
local scrheight = 1080
local scrwidth  = 1920

local createScratch = function(command, width, height)
  local scratch = bling.module.scratchpad {
    --command = terminal .. ' '
    command = terminal ..
        ' -n "' .. command .. 'pad' .. '" -c "' .. command .. 'pad" -e sh -c "' .. command .. '; $SHELL"',
    rule = { class = command .. 'pad' },
    sticky = true,
    autoclose = false,
    floating = true,
    geometry = { x = (scrwidth / 2) - width / 2, y = (scrheight / 2) - height / 2, height = height, width = width },
    reapply = true,
  }
  awesome.connect_signal('toggle::' .. command .. 'pad', function()
    scratch:toggle()
  end)
  return scratch
end
-- bling.widget.window_switcher.enable {
--   type = "thumbnail", -- set to anything other than "thumbnail" to disable client previews
--
--   -- keybindings (the examples provided are also the default if kept unset)
--   hide_window_switcher_key = "Space", -- The key on which to close the popup
--   minimize_key = "n", -- The key on which to minimize the selected client
--   unminimize_key = "N", -- The key on which to unminimize all clients
--   kill_client_key = "q", -- The key on which to close the selected client
--   cycle_key = "Tab", -- The key on which to cycle through all clients
--   previous_key = "Left", -- The key on which to select the previous client
--   next_key = "Right", -- The key on which to select the next client
--   vim_previous_key = "h", -- Alternative key on which to select the previous client
--   vim_next_key = "l", -- Alternative key on which to select the next client
--
--   cycleClientsByIdx = awful.client.focus.byidx, -- The function to cycle the clients
--   filterClients = awful.widget.tasklist.filter.currenttags, -- The function to filter the viewed clients
-- }
--
M.scratchpads = {
  default = createScratch('pfetch', 900, 680),
  ncmp = createScratch('ncmpcpp', 870, 600)
}

awful.screen.connect_for_each_screen(function(s)
  --Tiled Wallpaper
  -- bling.module.tiled_wallpaper(" ", s, {
  --   bg = beautiful.pri .. "ee",
  --   fg = beautiful.bg3,
  --   offset_y = 25,
  --   offset_x = 25,
  --   font = beautiful.icofont,
  --   font_size = 35,
  --   padding = 270,
  --   zickzack = true
  -- })
  -- Regular Wallpaper
  bling.module.wallpaper.setup {
    wallpaper = beautiful.wall
  }
end)

-- Start Window Swallowing
bling.module.window_swallowing.start()
return M
