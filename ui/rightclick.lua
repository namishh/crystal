local awful = require("awful")
local menu = require("mods.menu")
local hotkeys_popup = require("awful.hotkeys_popup")
local focused = awful.screen.focused()

local function awesome_menu()
  return menu({
    menu.button({
      icon = { icon = "", font = "Material Design Icons " },
      text = "Show Help",
      on_press = function()
        hotkeys_popup.show_help(nil, awful.screen.focused())
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "", font = "Material Design Icons" },
      text = "Docs",
      on_press = function()
        awful.spawn.with_shell("firefox https://awesomewm.org/apidoc/documentation/07-my-first-awesome.md.html#")
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰣕", font = "Material Design Icons" },
      text = "Edit Config",
      on_press = function()
        awful.spawn.with_shell("cd ~/.config/awesome && wezterm -e nvim" .. " " .. awesome.conffile)
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰦛", font = "Material Design Icons" },
      text = "Restart",
      on_press = function()
        awesome.emit_signal("close::menu")
        awesome.restart()
      end,
    }),
    menu.button({
      icon = { icon = "󰈆", font = "Material Design Icons" },
      text = "Quit",
      on_press = function()
        awesome.quit()
        awesome.emit_signal("close::menu")
      end,
    }),
  })
end

local function desktopMenu()
  return menu({
    menu.button({
      icon = { icon = "󱪞", font = "Material Design Icons " },
      text = "New File",
      on_press = function()
        awesome.emit_signal("toggle::popup", "create")
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰮝", font = "Material Design Icons" },
      text = "New Folder",
      on_press = function()
        awesome.emit_signal("close::menu")
        awesome.emit_signal("toggle::popup", "folder")
      end,
    }),
    menu.button({
      icon = { icon = "󰦛", font = "Material Design Icons" },
      text = "Refresh Icons",
      on_press = function()
        awesome.emit_signal("signal::desktop")
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰈈", font = "Material Design Icons" },
      text = "Toggle Icons",
      on_press = function()
        awesome.emit_signal("close::menu")
      end,
    }),
  })
end

local function widget()
  return menu({
    menu.button({
      icon = { icon = "󰍉", font = "Material Design Icons " },
      text = "Applications",
      on_press = function()
        awesome.emit_signal("toggle::launcher")
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󱃸", font = "Material Design Icons " },
      text = "Terminal",
      on_press = function()
        awful.spawn("wezterm", false)
      end,
    }),
    menu.button({
      icon = { icon = "󰈹", font = "Material Design Icons " },
      text = "Web Browser",
      on_press = function()
        awful.spawn("firefox", false)
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰉋", font = "Material Design Icons " },
      text = "File Manager",
      on_press = function()
        awful.spawn("nemo", false)
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󱇨", font = "Material Design Icons " },
      text = "Text Editor",
      on_press = function()
        awful.spawn("wezterm -e nvim", false)
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "", font = "Material Design Icons " },
      text = "Music Player",
      on_press = function()
        awesome.emit_signal("toggle::ncmpcpppad")
        awesome.emit_signal("close::menu")
      end,
    }),
    menu.button({
      icon = { icon = "󰐱", font = "Material Design Icons" },
      text = "Configure",
      on_press = function()
        awesome.emit_signal("close::menu")
        awesome.emit_signal("toggle::setup")
      end,
    }),
    menu.separator(),
    menu.sub_menu_button({
      icon = { icon = "󰖟", font = "Material Design Icons " },
      text = "AwesomeWM",
      sub_menu = awesome_menu(),
    }),
    menu.sub_menu_button({
      icon = { icon = "󰟀", font = "Material Design Icons " },
      text = "Desktop",
      sub_menu = desktopMenu(),
    }),
  })
end


local themenu = widget()


awesome.connect_signal("close::menu", function()
  themenu:hide(true)
end)
awesome.connect_signal("toggle::menu", function()
  themenu:toggle()
end)

return { desktop = themenu }
