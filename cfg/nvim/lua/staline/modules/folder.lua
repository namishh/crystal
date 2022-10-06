local fn = vim.fn

local M = function ()
  local icon = "%#StalineFolderIcon#" .. "  "
  local directory = "%#StalineFolderText#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
  return "%#StalineFolderSep#" .. "" .. icon .. directory .. "%#StalineEmptySpace#" .. " "
end

return M
