local diagnostic = vim.diagnostic
local M = function(m)
  local errors = #diagnostic.get(0, { severity = diagnostic.severity.ERROR })
  local warnings = #diagnostic.get(0, { severity = diagnostic.severity.WARN })
  local hints = #diagnostic.get(0, { severity = diagnostic.severity.HINT })
  local info = #diagnostic.get(0, { severity = diagnostic.severity.INFO })
  if (m == 'minimal') then
    ERROR = (errors and errors > 0) and
        ("%#StalineLspErrorIcon#" .. "X" .. "%#StalineLspError#" .. errors) or ""
    WARNING = (warnings and warnings > 0) and
        ("%#StalineLspWarningIcon#" .. "!" .. "%#StalineLspWarning#" .. warnings) or ""
    HINT = (hints and hints > 0) and
        ("%#StalineLspHintsIcon#" .. "@" .. "%#StalineLspHints#" .. hints) or ""
    INFO = (info and info > 0) and ("%#StalineLspInfoIcon#" .. "i" .. "%#StalineLspInfo#" .. info)
        or ""
  elseif (m == 'fancy') then
    ERROR = (errors and errors > 0) and
        ("%#StalineLspErrorIcon#" .. "X" .. "%#StalineLspError#" .. errors) or ""
    WARNING = (warnings and warnings > 0) and
        ("%#StalineLspWarningIcon#" .. "!" .. "%#StalineLspWarning#" .. warnings) or ""
    HINT = (hints and hints > 0) and
        ("%#StalineLspHintsIcon#" .. "@" .. "%#StalineLspHints#" .. hints) or ""
    INFO = (info and info > 0) and ("%#StalineLspInfoIcon#" .. "i" .. "%#StalineLspInfo#" .. info)
        or ""
  elseif (m == 'monochrome') then
    ERROR = (errors and errors > 0) and
        ("%#StalineLspErrorIconMono#" .. "X" .. "%#StalineLspErrorMono#" .. errors) or ""
    WARNING = (warnings and warnings > 0) and
        ("%#StalineLspWarningIconMono#" .. "!" .. "%#StalineLspWarningMono#" .. warnings) or ""
    HINT = (hints and hints > 0) and
        ("%#StalineLspHintsIconMono#" .. "@" .. "%#StalineLspHintsMono#" .. hints) or ""
    INFO = (info and info > 0) and ("%#StalineLspInfoIconMono#" .. "i" .. "%#StalineLspInfoMono#" .. info)
        or ""
  else
    return "F"
  end
  return ERROR .. " " .. WARNING .. " " .. HINT .. " " .. INFO .. " " .. "%#StalineEmptySpace#"
end
return M
