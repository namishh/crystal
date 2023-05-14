local awful = require 'awful'
local widgets = require 'config.menu'

awful.mouse.append_global_mousebindings {
  awful.button {
    modifiers = {},
    button    = 3,
    on_press  = function()
      widgets.mainmenu:toggle()
    end
  },
  awful.button {
    modifiers = {},
    button    = 1,
    on_press  = function()
      widgets.mainmenu:close()
    end
  },
  awful.button {
    modifiers = {},
    button    = 4,
    on_press  = awful.tag.viewprev
  },
  awful.button {
    modifiers = {},
    button    = 5,
    on_press  = awful.tag.viewnext
  },
}
