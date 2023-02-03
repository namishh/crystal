package = "rubato"
version = "1.2-1"
source = {
   url = "git+https://github.com/andOrlando/rubato.git"
}
description = {
   detailed = [[
Create smooth animations based off of a slope curve for near perfect interruptions. Similar to awestore, but solely dedicated to interpolation. Also has a cool name. Check out the README on github for more informaiton. Has (basically) complete compatibility with awestore.

If not ran from awesomeWM, you must have lgi installed. Otherwise you're good
]],
   homepage = "https://github.com/andOrlando/rubato",
   license = "MIT"
}
dependencies = {}
build = {
   type = "builtin",
   modules = {
      ["rubato"] = "init.lua",
      ["rubato.easing"] = "easing.lua",
      ["rubato.timed"] = "timed.lua",
      ["rubato.subscribable"] = "subscribable.lua",
      ["rubato.manager"] = "manager.lua"
   }
}
