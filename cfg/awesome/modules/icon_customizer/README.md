icon_customizer for awesomewm
==================

<p align="center">
  <img src="https://user-images.githubusercontent.com/1234183/123868520-193cba80-d930-11eb-8996-26541bca9c22.gif">
</p>

Features:
------------
- Define your own icons for applications
- Set custom icons for terminal applications based on client title

Prerequisite:
------------
Dynamic terminal icons (as shown on gif) require you to have a shell-terminal-stack that supports dynamic titles (the title of the client (`WM_NAME`) changes based on the running app or pwd).
Not every terminal or shell supports dynamic titles or is configured correctly out of the box.

Minimal configurations are provided for `bash` and `zsh`:

```
echo "source ~/.config/awesome/icon_customizer/dynamictitles.bash" >> ~/.bashrc
echo "source ~/.config/awesome/icon_customizer/dynamictitles.zsh" >> ~/.zshrc
```


Installation:
------------

Clone the repo and import the module:

1. `git clone https://github.com/intrntbrn/icon_customizer ~/.config/awesome/icon_customizer`
1. `echo "require('icon_customizer'){ delay = 0.2 }" >> ~/.config/awesome/rc.lua`

Example Configuration: 
------------
Define your custom icons in `theme.lua`:
```
local icon_dir = os.getenv("HOME") .. "/.config/awesome/icons/"
theme.ic_icons = {
	["Chromium"] = icon_dir .. "chromium.png",
	["firefox"] = icon_dir .. "firefox.png",
	["Zathura"] = icon_dir .. "zathura.png",
	["Steam"] = icon_dir .. "steam.png",
	["discord"] = icon_dir .. "discord.png",
	["Alacritty"] = icon_dir .. "terminal.png",
	["kitty"] = icon_dir .. "terminal.png"
}

theme.ic_dynamic_classes = { "Alacritty", "kitty", "St", "URxvt", "Termite" }
theme.ic_dynamic_icons = {
	["- NVIM$"] = icon_dir .. "vim.png",
	["- VIM$"] = icon_dir .. "vim.png",
	["- TMUX$"] = icon_dir .. "tmux.png",
	["^ranger$"] = icon_dir .. "file-manager.png",
	["^spt$"] = icon_dir .. "spotify.png",
	["^googler$"] = icon_dir .. "google.png",
	["- rtv"] = icon_dir .. "reddit.png"
}

theme.ic_fallback_icon = icon_dir .. "default_icon.png"

```

Get application class names or titles by using `xprop`.

Limitations:
------------
Applications can still overwrite your custom icon.

Related Work:
------------

* icons: [numix circle](https://github.com/numixproject/numix-icon-theme-circle)
* awesomewm taglist: [fancy_taglist](https://gist.github.com/intrntbrn/08af1058d887f4d10a464c6f272ceafa)
