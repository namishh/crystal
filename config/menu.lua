local _M = {}
local awful = require("awful")
local beautiful = require("beautiful")
local apps = require 'config.apps'
local gcolor = require('gears.color')
local wibox = require("wibox")
local gfilesystem = require('gears.filesystem')
local icondir = gfilesystem.get_configuration_dir() .. 'theme/icons/desk/'

local cm = require 'modules.menu'

local menu = cm {
  widget_template = wibox.widget {
    {
      {
        {
          {
            widget = wibox.widget.imagebox,
            resize = true,
            valign = 'center',
            halign = 'center',
            id = 'icon_role',
          },
          widget = wibox.container.constraint,
          stragety = 'exact',
          width = 40,
          height = 24,
          id = 'const',
        },
        {
          widget = wibox.widget.textbox,
          valign = 'center',
          halign = 'left',
          id = 'text_role',
        },
        layout = wibox.layout.fixed.horizontal,
      },
      widget = wibox.container.margin,
      margins = 6,
    },
    forced_width = 100,
    widget = wibox.container.background,
  },
  spacing = 10,
  entries = {
    {
      name = 'New File     ',
      icon = gcolor.recolor_image(icondir .. 'file.svg', beautiful.pri),
      callback = function()
        awesome.emit_signal('create::something', 'file')
      end,
    },
    {
      name = 'New Folder',
      icon = gcolor.recolor_image(icondir .. 'folder.svg', beautiful.ok),
      callback = function()
        awesome.emit_signal('create::something', 'folder')
      end,
    },
    {
      name = 'New Shortcut',
      icon = gcolor.recolor_image(icondir .. 'launch.svg', beautiful.dis),
      callback = function()
        awesome.emit_signal('create::something', 'shortcut')
      end,
    },
    {
      name = 'Refresh',
      icon = gcolor.recolor_image(icondir .. 'refresh.svg', beautiful.err),
      callback = function()
        awesome.emit_signal('desktop::refresh')
      end,
    },
    {
      name = 'Toggle Icons',
      icon = gcolor.recolor_image(icondir .. 'search.svg', beautiful.warn),
      callback = function()
        awesome.emit_signal("toggle::desktop")
      end,
    },
    {
      name = 'Open In Terminal',
      icon = gcolor.recolor_image(icondir .. 'terminal.svg', beautiful.fg),
      callback = function()
        awful.spawn.with_shell('kitty -e sh -c "cd Desktop; $SHELL"')
      end,
    },
    {
      name = 'Awesome',
      icon = gcolor.recolor_image(gfilesystem.get_configuration_dir() .. 'theme/icons/' .. 'awesomewm.svg', beautiful
        .pri),
      submenu = {
        {
          name = 'Open Docs',
          icon = gcolor.recolor_image(icondir .. 'web.svg', beautiful.ok),
          callback = function()
            awful.spawn.with_shell("firefox https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#")
          end,
        },
        {
          name = 'Open Config',
          icon = gcolor.recolor_image(icondir .. 'text.svg', beautiful.pri),
          callback = function()
            awful.spawn.with_shell('kitty -e sh -c "cd ~/.config/awesome ; nvim rc.lua ; $SHELL"')
          end,
        },
        {
          name = 'Restart',
          icon = gcolor.recolor_image(icondir .. 'refresh.svg', beautiful.err),
          callback = function()
            awesome.restart()
          end,
        },
        {
          name = 'Exit',
          icon = gcolor.recolor_image(icondir .. 'logout.svg', beautiful.dis),
          callback = function()
            awesome.quit()
          end,
        },
      }
    },
  }
}
_M.mainmenu = menu


return _M
