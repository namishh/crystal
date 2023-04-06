local _M = {}
local hotkeys_popup = require 'awful.hotkeys_popup'
local awful = require("awful")
local beautiful = require("beautiful")
local apps = require 'config.apps'
_M.awesomemenu = {
  { 'Hotkeys',     function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
  { 'Manual',      apps.manual_cmd },
  { 'Edit Config', apps.editor_cmd .. ' ' .. awesome.conffile },
  { 'Restart',     awesome.restart },
  { 'Quit',        awesome.quit },
}
_M.filemenu = {
  { 'New File',     function() awesome.emit_signal('create::something', 'file') end },
  { 'New Folder',   function() awesome.emit_signal('create::something', 'folder') end },
  { 'New Shortcut', function() awesome.emit_signal('create::something', 'shortcut') end },
  { 'Toggle Icons', function() awesome.emit_signal("toggle::desktop") end },
  { 'Refresh',      awesome.restart },
}
_M.mainmenu = awful.menu {
  items = {
    { 'Awesome',  _M.awesomemenu, beautiful.awesome_icon },
    { 'Files',    _M.filemenu,    beautiful.awesome_icon },
    { 'Terminal', apps.terminal }
  }
}


return _M
