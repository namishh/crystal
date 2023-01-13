# Awesome AwesomeWM RC

This is the default **[awesome-git](https://awesomewm.org/apidoc/)** `rc.lua`, 
but structured for better customization and modularity. Initially, i did 
it for myself, because i needed something to start with, and i decided to 
share because i didn't find anything similar. None of the logic was touched, 
but everything was reformatted to match the code style that i like.

Please note that this is for **[awesome-git](https://awesomewm.org/apidoc/)** 
and will not work with the stable release. 

## Structure

The main `rc.lua` file only load the modules it was split into.
Each module can have its own submodules, and they are all loaded from `init.lua`.

module | description
-------- | -----------
`bindings` | mouse and key bindings
`config` | various variables for apps/tags etc...
`modules` | third-party libraries (e.g. [bling](https://github.com/BlingCorp/bling), [lain](https://github.com/lcpz/lain))
`rules` | client rules
`signals` | all signals are connected here
`widgets` | all widgets are defined here

The `widgets` module is now better organized in the 
[`widgets`](https://github.com/suconakh/awesome-awesome-rc/tree/widgets) branch.
The reason for moving it to a different branch is that it is now 
a bit different from the default `rc.lua` logic, so I decided to 
move it to a different branch so as not to create confusion.

Feel free to submit PRs!

## Credits

[This config](https://git.linuxit.us/spider/awesome/src/commit/921c5019df6a03915e09efcb1336bbca518a4401) was used as a base.
