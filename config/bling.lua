local beautiful     = require 'beautiful'
local bling         = require("modules.bling")
local terminal      = require 'config.apps'.terminal
local helpers       = require("helpers")
local xresources    = require("beautiful.xresources")
local dpi           = xresources.apply_dpi
local M             = {}

local scrheight     = beautiful.scrheight
local scrwidth      = beautiful.scrwidth

local createScratch = function(command, width, height)
  local scratch = bling.module.scratchpad {
    --command = terminal .. ' '
    command = terminal .. ' -c "' .. command .. 'pad" -e sh -c "' .. command .. '; $SHELL"',
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
M.scratchpads       = {
  default = createScratch('pfetch', 900, 680),
  ncmp = createScratch('ncmpcpp', 950, 600)
}

local args          = {
  terminal = "st",
  favorites = { "firefox", "st", "discord" },
  search_commands = true,
  skip_empty_icons = true,
  sort_alphabetically = true,
  hide_on_left_clicked_outside = true,
  hide_on_right_clicked_outside = true,
  try_to_keep_index_after_searching = false,
  save_history = true,
  background = beautiful.bg,
  shape = helpers.rrect(4),
  prompt_height = dpi(60),
  prompt_paddings = dpi(20),
  prompt_margins = {
    top = dpi(20),
    left = dpi(20),
    right = dpi(20),
    bottom = 0,
  },
  prompt_text = "> ",
  prompt_color = beautiful.bg2,
  prompt_icon_markup = helpers.colorizeText("", beautiful.fg),
  prompt_text_color = beautiful.fg,
  prompt_cursor_color = beautiful.fg .. "33",
  apps_per_column = 1,
  apps_per_row = 6,
  app_icon_halign = "left",
  app_icon_valign = "left",
  app_name_halign = "center",
  app_selected_color = beautiful.bg2,
  app_normal_color = beautiful.bg,
  app_name_normal_color = beautiful.fg,
  app_name_selected_color = beautiful.fg,
  app_name_font = beautiful.font .. " 12",
  app_icon_width = dpi(32),
  app_content_spacing = dpi(20),
  app_icon_height = dpi(32),
  app_width = dpi(340),
  app_height = dpi(65),
  icon_size = 28,
  apps_spacing = dpi(5),
  app_shape = helpers.rrect(5)
}
local app_launcher  = bling.widget.app_launcher(args)

awesome.connect_signal('toggle::app_launcher', function()
  app_launcher:toggle()
end)

M.app_launcher = app_launcher
-- Start Window Swallowing
bling.module.window_swallowing.start()
return M
