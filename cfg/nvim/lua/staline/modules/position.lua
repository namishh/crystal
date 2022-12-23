local fn = vim.fn
local M = function(m)
  local current = fn.line "."
  local total = fn.line "$"
  if (m == 'minimal') then
    return "%#StalineProgress#" ..
        " " .. current .. "/" .. total .. " " .. "%#StalineProgressIcon#" .. " " .. "%#StalineEmptySpace#"
  elseif (m == 'fancy') then
    return "%#StalineProgressIcon#" ..
        "  " .. "%#StalineProgress#" .. " " .. current .. "/" .. total .. " " .. "%#StalineEmptySpace#"
  elseif (m == 'monochrome') then
    return "%#StalineProgressIconMono#" ..
        " " .. "%#StalineProgressMono#" .. " " .. current .. "/" .. total .. " " .. "%#StalineEmptySpace#"
  else
    return "F"
  end
end

return M
