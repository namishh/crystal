local fn = vim.fn

local M = function(m)
  if (m == 'minimal') then
    local directory = "%#StalineFolderText#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
    local icon = "%#StalineFolderIcon#" .. " DIR "
    return icon .. directory .. "%#StalineEmptySpace#" .. " "
  elseif (m == 'fancy') then
    local directory = "%#StalineFolderText#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
    local icon = "%#StalineFolderIcon#" .. "  "
    return "%#StalineFolderSep#" .. "" .. icon .. directory .. "%#StalineEmptySpace#" .. " "
  elseif (m == 'monochrome') then
    local directory = "%#StalineFolderTextMono#" .. " " .. fn.fnamemodify(fn.getcwd(), ":t") .. " "
    local icon = "%#StalineFolderIconMono#" .. "   "
    return icon .. directory .. "%#StalineEmptySpace#" .. " "
  else
    return 'f'
  end
end

return M
