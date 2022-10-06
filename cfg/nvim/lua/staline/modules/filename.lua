local fn = vim.fn
local M = function ()
  local icon = "  "
  local filename = (fn.expand "%" == "" and "Empty ") or fn.expand "%:t"
  if filename == "NvimTree_1" then
    filename = "File Explorer"
  end
  if filename == "[startuptime]" then
    filename = "Startup Time"
  end
  if string.find(filename, "toggleterm") then
    filename = "Terminal"
  end
  if filename ~= "Empty " then
    local devicons = require("nvim-web-devicons")
    local ft_icon = devicons.get_icon(filename)
    icon = (ft_icon ~= nil and " " .. ft_icon) or ""
  end
  return "%#StalineFilename#" .. icon .. "  " .. filename .. "  "
end
return M
