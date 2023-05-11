kind of borked rn <br>
nuclear config only meant to work with my nixos config<br>

the liblua_pam.so is compiled with lua5.2. either use lua5.2 or compile your own

### Setup

1. Install these programs
```txt
awesome-git zsh pamixer imagemagick ncmpcpp mpd mpDris2 brightnessctl inotifywait uptime brillo networkmanager bluetoothctl picom
```

2. If you are using my nixos config, then my config should be already installed, otherwise
```bash
~ $ git clone --depth 1 --branch the-awesome-config https://github.com/chadcat5207/fuyu ~/.config/awesome
```

3. Make a secrets file at `config/key.lua`
```lua
local M = {
  openweatherapi = "your_key_here",
  password = "here",
}

return M
```

### Colors on other distros

+ WARNING : It may / may not work on your system.

Make a file called `theme/colors.lua`. <br>
This file is where you define all your colors, gtkTheme (i do not use this), icon theme and wallpaper

```lua
-- This is a sample file
local M = {}

M.name  = 'pop'
M.wall  = '/path/to/wallpaper.png'
M.ow = "wallpaper.png" -- only the name of the wallpaper
M.iconTheme = "./icons/Reversal"
M.gtkTheme = 'popgtk'

M.ok    = "#56966e"
M.warn  = "#dcae61"
M.err   = "#c14d53"
M.pri   = "#6e95bd"
M.dis   = "#a56db1"

M.bg    = "#0c0c0c"
M.mbg   = "#181817"
M.bg2   = "#191919"
M.bg3   = "#1b1b1b"
M.bg4   = "#272727"

M.fg    = "#dfdddd"
M.fg2   = "#b7b7b7"
M.fg3   = "#d4d5d5"
M.fg4   = "#5a5858"

return M
```

I do not have this file in this config, as it is automatically generated including the gtkTheme using home-manager in my config! <br>

#### Changing Themes
This is something that I do not handle as I use NixOs, but this is a sample function I used when I used Endevaour Os and Void.
```lua
local colors       = require("theme.colors")

local setTheme     = function()
  awful.spawn.with_shell('xrdb -remove')
  awful.spawn.with_shell('xrdb -merge ~/.palettes/' .. colors.name .. " && kill -USR1 $(pidof st)")
  awful.spawn.with_shell('cp ~/.config/rofi/colors/' .. colors.name .. '.rasi ~/.config/rofi/colors.rasi')
  awful.spawn.with_shell("sed -i '2s/.*/gtk-theme-name=" .. colors.gtkTheme .. "/g' ~/.config/gtk-3.0/settings.ini")
end

setTheme()
```

### Todo (13/17)
- [x] ~~control center~~
- [x] ~~dock~~
- [x] ~~calendar good looks~~
- [x] ~~desktop icon~~
- [x] ~~window swallowing~~
- [x] ~~scatchpads simple implementation~~
- [x] ~~make a pomo timer~~

#### Easy
- [x] ~~appmenu~~
- [x] ~~lock~~
- [x] ~~vid recorder~~
- [x] ~~screenshoter~~
- [x] ~~wallpaper switcher~~

#### Tough
- [ ] notifications for network and battery
- [ ] right click menu
- [ ] make a todo list widget
- [ ] focus mode?


#### Fixes
- [x] ~~make it so that new apps spawn at last in the dock~~

### Credits
will add them here
