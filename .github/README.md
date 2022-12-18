<div align="center">

# Dots.sh

</div>

My dotfiles based on my own personal taste

![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/1.png)

![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/2.png)

![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/3.png)


**!! IMPOTANT** -- if the dots work for me, does'nt mean it would also work for you

## Application And Utilites
+ WM - suckless's dwm
+ Terminal - suckless's st
+ Menu - dmenu
+ Compositer - picom
+ Editor - [My Neovim Config](https://github.com/dark-Jedi2108/nvide)
+ GUI File Manager - nemo
+ Terminal File Manager - lf
+ hotkey daemon - sxhkd
+ Audio Visualizer - Cava
+ Discord Enhancer - betterdiscord
+ Fetch Util - Neofetch
+ Spotify Enhancer - spicetify
+ Lock Screen - slock

## Touch To Tap Util

Edit `/etc/X11/xorg.conf.d/90-touchpad.conf` with admin perms

```conf
Section "InputClass"
        Identifier "touchpad"
        MatchIsTouchpad "on"
        Driver "libinput"
        Option "Tapping" "on"
EndSection
```

