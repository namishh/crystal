nuclear config only meant to work with my nixos config

### Running On Others Distrobutions

+ This is not an exact step by step tutorial
+ WARNING : It may / may not work on your system.

First, you will need some programs <br>
```txt
awesome-git zsh pamixer ncmpcpp mpd mpDris2 brightnessctl uptime brillo networkmanager bluetoothctl reshift picom
```

Then you will need to make a file called `theme/colors.lua`. <br>
This file is where you define all your colors, gtkTheme (i do not use this), icon theme and wallpaper

```lua
-- This is a sample file
local M = {}

M.name  = 'pop'
M.wall  = '/path/to/wallpaper.png'
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
