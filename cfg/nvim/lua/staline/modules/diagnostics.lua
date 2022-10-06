local diagnostic = vim.diagnostic
local M = function()
  local errors = #diagnostic.get(0, { severity = diagnostic.severity.ERROR })
  local warnings = #diagnostic.get(0, { severity = diagnostic.severity.WARN })
  local hints = #diagnostic.get(0, { severity = diagnostic.severity.HINT })
  local info = #diagnostic.get(0, { severity = diagnostic.severity.INFO })
  local errorstr = (errors and errors > 0) and
      ("%#StalineLspErrorIcon#" .. "X" .. "%#StalineLspError#" .. " " .. errors .. "  ") or ""
  local warningstr = (warnings and warnings > 0) and
      ("%#StalineLspWarningIcon#" .. "!" .. "%#StalineLspWarning#" .. " " .. warnings .. "  ") or ""
  local hintstr = (hints and hints > 0) and
      ("%#StalineLspHintsIcon#" .. "@" .. "%#StalineLspHints#" .. " " .. hints .. "  ") or ""
  local infostr = (info and info > 0) and ("%#StalineLspInfoIcon#" .. "i" .. "%#StalineLspInfo#" .. " " .. info .. "  ")
      or ""
  return errorstr .. warningstr .. hintstr .. infostr .. "%#StalineEmptySpace#" .. " "
end
return M
