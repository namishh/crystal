## aura

The newer and much better rice.

### Features
+ Desktop Icons completely implemented in awesome. Now with drag and drop
+ Cool Titlebars
+ Modern Panel with windows like taskbar
+ Dashboard with pomodoro and Todo
+ Control panel 
+ Configure Widget
+ Better right click menu with icons
+ Calendar and Weather Widget
+ i3lock-color like lockscreen with profile picture
+ Minimal no-nonsense exit screen
+ Application Launcher
+ Good Looking notifications
+ Mouse friendly custom ncmpcpp ui
+ Screenshotter


### Setup on other distros

1. Install these programs

```txt
awesome-git zsh pamixer imagemagick ncmpcpp mpd mpDris2 neofetch brightnessctl inotifywait uptime brillo networkmanager bluetoothctl picom redshift wezterm
```

2. Clone the repo
```
~ $ git clone --depth 1 --branch aura https://github.com/chadcat7/crystal ~/.config/awesome
```

3. Make this executable file `~/.local/bin/lock` 
```bash
#!/bin/sh
playerctl pause
sleep 0.2
awesome-client "awesome.emit_signal('toggle::lock')"
```

#### Changing Themes
This is something that I do not handle as I use NixOs, but this is a sample function I used when I used Endevaour Os and Void.

```lua

local setTheme     = function(name)
  awful.spawn.with_shell('xrdb -remove')
  awful.spawn.with_shell('xrdb -merge ~/.palettes/' .. name .. " && kill -USR1 $(pidof st)")
  awful.spawn.with_shell("cp ~/.config/awesome/theme/colors/" .. name .. ".lua ~/.config/awesome/theme/colors.lua")
  awful.spawn.with_shell('cp ~/.config/rofi/colors/' .. name .. '.rasi ~/.config/rofi/colors.rasi')
end

```


3. Edit keys in `~/.cache/awesome/json/settings.json`

### Screenshots

| <b>Control Center</b>                                                                              |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/01.jpg" alt="bottom panel preview"></a>|

| <b>DashBoard</b>                                                                                               |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/02.jpg" alt="bottom panel preview"></a>|

| <b>Notification Center</b>                                                                                   |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/03.jpg" alt="bottom panel preview"></a>|
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/04.jpg" alt="bottom panel preview"></a>|

| <b>Exit Screen And Lock</b>                                                                            |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/07.jpg" alt="bottom panel preview"></a>|
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/11.jpg" alt="bottom panel preview"></a>|


| <b>Calendar + Weather Widget</b>                                                                                   |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/05.jpg" alt="bottom panel preview"></a>|


| <b>Configure Widget</b>                                                                                            |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/06.jpg" alt="bottom panel preview"></a>|

| <b>App Menu</b>                                                                                                    |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/10.jpg" alt="bottom panel preview"></a>|

| <b>Custom Ncmpcppp UI</b>                                                                                          |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/09.jpg" alt="bottom panel preview"></a>|
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/08.jpg" alt="bottom panel preview"></a>|


| <b>Right Click Menu </b>                                                                                          |
| ------------------------------------------------------------------------------------------------------------------ |
| <a href="#--------"><img src="https://raw.githubusercontent.com/chadcat7/crystal/aura/.github/screenshots/12.jpg" alt="bottom panel preview"></a>|

