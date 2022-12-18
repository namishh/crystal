local fn = vim.fn
local M = function()
  local current = fn.line "."
  local total = fn.line "$"
  -- return "%#StalineProgressIcon#" .. "  " .. "%#StalineProgress#" .. " " .. current .. "/" .. total .. " " .. "%#StalineEmptySpace#"
  return "%#StalineProgress#" ..
      " " .. current .. "/" .. total .. " " .. "%#StalineProgressIcon#" .. " " .. "%#StalineEmptySpace#"

end

return M
