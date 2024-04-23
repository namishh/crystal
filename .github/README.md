# Modularized example rc.lua

This project is essentially a template for my (and your) convenience when
starting a new AwesomeWM configuration. It's loyal to the 
[official example](https://github.com/awesomeWM/awesome/blob/master/awesomerc.lua)
, but way more digestible and generally cleaned up. It also contains some
personal notes on useful things I've learned while using AwesomeWM.


# Why?

There exist a few similar projects that aim to make starting out with AWM a
bit easier, but in my opinion, they fail in some regards. They either:
- Abuse global variables and functions.
- Have obtuse and counterintuitive organization.

I aimed to make something that I found more comfortable to work with, and I'm doing
you the further courtesy of sharing it. Think this is pointless? You're probably
right.


# Structure

This project is divided into different directories that aim to provide cohesive configuration.
- `binds` is fairly straight forward, it contains all key and mouse bindings that the WM uses.
They're additionally split up into client (window) bindings and global (WM) bindings.
- `config` contains general user-preference customization like default applications, layouts,
tag number and names, and WM rules.
- `module` is a dummy directory for you to put community developed modules into. Some common
examples are [rubato](https://github.com/andOrlando/rubato) and 
[bling](https://github.com/blingcorp/bling).
- `signal` contains the AwesomeWM signals that trigger events like tag creation and widget
drawing. This one is easier to understand after you've used AWM for a while.
- `theme` is mostly a dummy directory that currently only includes the `beautiful` initialization
but is intended for you to expand with your own themes. An example of this idea can be found
in one of my personal configurations, [gwileful](https://github.com/Gwynsav/gwileful/tree/widgets/theme).
- `ui` contains all widgets and UI elements, providing a table with all of them for easy access.
- And finally, `rc.lua` just calls whatever needs to be called and handles errors.


# How do I get started?

Simply clone the repository into your AwesomeWM configuration directory and start
working!
```sh
# Assuming that ~/.config exists and is a directory.
git clone https://github.com/gwynsav/modular-awm-default.git ~/.config/awesome
```


# Any other recommendations?

Yes! You may be interested in compiling AwesomeWM against LuaJIT as it basically
just performs better. Instructions on how to do this can be found in the [official
AWM documentation](https://awesomewm.org/apidoc/documentation/10-building-and-testing.md.html).

While we're on the topic of documentation, here's a link to the [official documentation
for the master branch of Awesome](https://awesomewm.org/apidoc). Why the master branch?
Because, as of the end of 2023, the stable release is about 4 years behind in development.
I would recommend against using it as this project **doesn't work with it**.
