# Phocus GTK3 Theme
This GTK3 theme is part of the [Phocus](https://github.com/phocus/) theme collection.

## Installation From source
Make sure to install the following dependency:

- [npm](https://www.npmjs.com/)

Clone the phocus/gtk repository and build/install it using make:

```bash
git clone https://github.com/phocus/gtk.git phocus-gtk
cd phocus-gtk
make
sudo make install
```

## Installation on Arch
Install the AUR package [phocus-gtk-theme-git](https://aur.archlinux.org/packages/phocus-gtk-theme-git/) with your favourite AUR helper (or by hand, won't judge).
```bash
paru -S phocus-gtk-theme-git
```

## Development
To make development as easy as possible, clone the repository and symlink it into your users `~/.themes` directory:
```bash
git clone https://github.com/phocus/gtk.git ~/code/phocus
ln -s ~/code/phocus ~/.themes/phocus
```

Install its npm dependencies:
```bash
cd ~/.themes/phocus
npm install
```

### Build
Build the theme by running its build script:
```bash
npm run build
```

### Watch
Start a watcher that automatically builds when you modify a file:
```bash
cd ~/themes/phocus
npm run watch
```

### Reload GTK Theme
Make all open GTK applications reload the phocus theme by running:
```bash
npm run reload_gtk_theme
```

This requires you to have [xsettingsd](https://github.com/derat/xsettingsd) installed.

### Watch and reload - *ultimate comfort*
Automatically build on modifications, and make all open GTK applications reload the phocus theme:
```bash
npm run watch_and_reload
```

Enjoy this quick demo of the ultimate comfort workflow:
![ultimate comfort demo](https://i.imgur.com/UjUpmG1.gif)

## Desktop Makers

<a href="https://discord.gg/RqKTeA4uxW" title="Desktop Makers Discord"><img align="left" width="72" alt="type=discord" src="https://user-images.githubusercontent.com/1282767/161089772-d7ad28bf-76eb-4951-b0f0-985afd5ea57a.png"></a>

I am actively working on phocus and other cool projects on the [Desktop Makers Discord](https://discord.gg/RqKTeA4uxW). It aims to be a community for communities of Linux desktop related projects. If you are looking to collaborate with or want to contribute to great projects, this might be the right place for you.
