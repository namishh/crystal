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

### Other Distros

Create these files.
1. `theme/colors/verdant.lua`

```lua
local M = {}

M.name  = 'verdant'
M.wall  = '/path/to/wallpaper.png'
M.ow = "wallpaper.png" -- only the name of the wallpaper
M.iconTheme = "./icons/Reversal"
M.gtkTheme = 'popgtk' -- just set name of any gtk you have installed or make one for this theme

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

2. `theme/pop/cat.lua`
```lua
local M = {}

M.name  = 'cat'
M.ow = 'girlwithcat.jpg'
M.wall  = '~/.config/awesome/theme/wallpapers/cat/girlwithcat.jpg'
M.iconTheme = "./icons/Reversal"
M.gtkTheme = 'catgtk'

M.ok    = "#A6D189"
M.warn  = "#E5C890"
M.err   = "#E78284"
M.pri   = "#8CAAEE"
M.dis   = "#F4B8E4"
M.bg    = "#11111b"
M.mbg   = "#1b1b29"
M.bg2   = "#1e1e2e"
M.bg3   = "#3a3e4b"
M.bg4   = "#3b3e48"
M.fg    = "#f5e0dc"
M.fg2   = "#B5BFE2"
M.fg3   = "#83889a"
M.fg4   = "#6c7086"

return M
```

3. `theme/colors/wave.lua`
```lua
local M = {}

M.name  = 'wave'
M.ow = 'sea.jpg'
M.wall  = '~/.config/awesome/theme/wallpapers/wave/sea.jpg'
M.gtkTheme = 'somebluetheme'

M.ok    = "#6ec587"
M.warn  = "#deb26a"
M.err   = "#df5b61"
M.pri   = "#659bdb"
M.dis   = "#c167d9"
M.bg    = "#0a1011"
M.mbg   = "#0e1718"
M.bg2   = "#101a1b"
M.bg3   = "#0d1617"
M.bg4   = "#253336"
M.fg    = "#d7e0e0"
M.fg2   = "#c5d7d7"
M.fg3   = "#cedcd9"
M.fg4   = "#505758"

return M
```

4. `theme/colors/forest.lua`
```lua
local M = {}

M.name  = 'wave'
M.ow = 'sea.jpg'
M.wall  = '~/.config/awesome/theme/wallpapers/wave/sea.jpg'
M.gtkTheme = 'somebluetheme'

M.ok    = "#6ec587"
M.warn  = "#deb26a"
M.err   = "#df5b61"
M.pri   = "#659bdb"
M.dis   = "#c167d9"
M.bg    = "#0a1011"
M.mbg   = "#0e1718"
M.bg2   = "#101a1b"
M.bg3   = "#0d1617"
M.bg4   = "#253336"
M.fg    = "#d7e0e0"
M.fg2   = "#c5d7d7"
M.fg3   = "#cedcd9"
M.fg4   = "#505758"

return M
```
Copy any one theme to `theme/colors.lua` which will be theme currently in use
```bash
$ cp ~/.config/awesome/theme/colors/verdant.lua ~/.config/awesome/theme/colors.lua
```

#### Changing Themes
This is something that I do not handle as I use NixOs, but this is a sample function I used when I used Endevaour Os and Void.

Replace this setTheme function with the one i used in `ui/control/modules/themer.lua`
```lua

local setTheme     = function(name)
  awful.spawn.with_shell('xrdb -remove')
  awful.spawn.with_shell('xrdb -merge ~/.palettes/' .. name .. " && kill -USR1 $(pidof st)")
  awful.spawn.with_shell("cp ~/.config/awesome/theme/colors/" .. name .. ".lua ~/.config/awesome/theme/colors.lua")
  awful.spawn.with_shell('cp ~/.config/rofi/colors/' .. name .. '.rasi ~/.config/rofi/colors.rasi')
end

```

### Todo (14/15)
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
- [x] ~~right click menu~~
- [x] complete the dash


#### Fixes
- [x] ~~make it so that new apps spawn at last in the dock~~

### Credits
will add them here
