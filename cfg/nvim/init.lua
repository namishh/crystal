vim.defer_fn(function()
  pcall(require, "impatient")
end, 0)
require('themes') -- Lua Colorshceme
-- Core Configuration
require("core.options")
require("core.keybinds")

-- Setting The Statusline
vim.opt.statusline = "%!v:lua.require('staline').run()"

require("plugins") -- All The Plugins
