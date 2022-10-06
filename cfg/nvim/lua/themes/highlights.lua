local M = {}
local hi = vim.api.nvim_set_hl
local config = require('themes.config')

function M.highlight_all(colors, opts)
  if opts.transparent_background == true then
    colors.background = "none"
  end
  local base_highlights = config.highlights_base(colors)
  for group, properties in pairs(base_highlights) do
    hi(0, group, properties)
  end
end

return M
