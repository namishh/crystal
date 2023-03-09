<div align="center">

# dots.sh

</div>

~ My awesome and dwm dotfiles ~

### Awesome
![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/a1.png)
![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/a2.png)
![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/a3.png)
![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/a4.png)

### DWM
![Screenshot1](https://raw.githubusercontent.com/dark-Jedi2108/dots.sh/main/.github/screenshots/dwm.png)


**!! IMPOTANT** -- if the dots work for me, does'nt mean it would also work for you

## Application And Utilites
+ WM - suckless's dwm and awesome-git (currently using)
+ Terminal - suckless's st
+ Menu - bling menu customised
+ Compositer - picom
+ Editor - [My Neovim Config](https://github.com/dark-Jedi2108/nvide)
+ GUI File Manager - nemo
+ Terminal File Manager - lf
+ hotkey daemon - sxhkd
+ Audio Visualizer - cava
+ Discord Enhancer - betterdiscord
+ Fetch Util - Neofetch, pfetch
+ Spotify Enhancer - spicetify
+ Lock Screen - i3lock-color (awesome), slock (dwm)

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

