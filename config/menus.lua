local _M = {}
local hotkeys_popup = require 'awful.hotkeys_popup'
local awful = require("awful")
local beautiful = require("beautiful")
local apps = require 'config.apps'
_M.awesomemenu = {
  { 'hotkeys', function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { 'manual', apps.manual_cmd },
  { 'edit config', apps.editor_cmd .. ' ' .. awesome.conffile },
  { 'restart', awesome.restart },
  { 'quit', awesome.quit },
}
_M.mainmenu = awful.menu {
  items = {
    { 'awesome', _M.awesomemenu, beautiful.awesome_icon },
    { 'terminal', apps.terminal }
  }
}

return _M
