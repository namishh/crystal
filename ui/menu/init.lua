local awful      = require('awful')
local beautiful  = require('beautiful')

--- Menu
local menu       = {}
local apps       = require('config.apps')
local hkey_popup = require('awful.hotkeys_popup')

-- Create a main menu.
menu.awesome     = {
  { 'hotkeys', function() hkey_popup.show_help(nil, awful.screen.focused()) end },
  { 'manual',  apps.terminal .. ' -e man awesome' },
  -- Not part of the original config but extremely useful, especially as the example
  -- config is meant to serve as an example to build your own environment upon.
  {
    'docs',
    (os.getenv('BROWSER') or 'firefox') .. ' https://awesomewm.org/apidoc'
  },
  { 'edit config', apps.editor_cmd .. ' ' .. awesome.conffile },
  { 'restart',     awesome.restart },
  { 'quit',        function() awesome.quit() end }
}

menu.main        = awful.menu({
  items = {
    { 'awesome',       menu.awesome, beautiful.awesome_icon },
    { 'open terminal', apps.terminal }
  }
})

return menu
