<div align='center'>
  <h1>冬 | fuyu | winter</h1>
  <h4>nix dotfiles that will 200% break your system</h4>
</div>

## Installation
Please make your own dotfiles, copying them is a bad idea as they are made specifically for my machine and there is 1/6th chance that this will make you end up in North Korea's assassination list. <br>
You have been warned! <br>

1. Get the latest [NixOS ISO](https://nixos.org/download.html) and boot into the installer/environment.
2. Format and mount your disks.
3. Follow these commands (you might need root privileges):

```bash
$ nix-shell -p git nixUnstable ## install git and unstable nix
```

```bash
$ git clone --depth 1 https://github.com/chadcat7/fuyu /mnt/etc/nixos --recurse-submodules ## cloning my config
```

```bash
$ rm /mnt/etc/nixos/hosts/<your host>/hardware-configuration.nix ## remove the hardware-configuration.nix for my system!
```

```bash
$ nixos-generate-config --root /mnt ## generate yours
$ cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/<your host>/
$ rm /mnt/etc/nixos/configuration.nix
```

```bash
$ cd /mnt/etc/nixos
$ nixos-install --flake '.#nixl'
```

Congrats! You just installed NixOS! Now lets install the environment and the configs

4. Reboot, login as root, and change the password for your user using `passwd`.
5. Log in as your normal user.
6. Follow these commands:

```bash
sudo chown -R $USER /etc/nixos # change ownership of configuration folder
cd /etc/nixos
home-manager switch --flake '.#namish' # this should automatically install nvim and awesome config
```


## Todo
somethings i need to do before i can call it fully usable - <br>
- [x] Install phocus with dynamic theming 
- [x] Install any image colorizer
- [ ] Lock screen setup
- [ ] Add Screenshots

Credits -
These are the chads which helped me throughout my short but crazy nix journey!
- [gw](https://github.com/Gwynsav)
- [javacafe](https://github.com/JavaCafe01/)
- [f2k](https://github.com/fortuneteller2k/)
- [apro](https://github.com/Aproxia-dev)
