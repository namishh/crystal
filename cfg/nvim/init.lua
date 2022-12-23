vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)
require('themes') -- Lua Colorshceme
-- Core Configuration
require("core.options")
require("core.keybinds")
require("plugins") -- All The Plugins
