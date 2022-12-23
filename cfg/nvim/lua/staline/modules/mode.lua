local api = vim.api
local modes = {
  ["n"] = { "NORMAL", "StalineNormalMode" },
  ["niI"] = { "NORMAL i", "StalineNormalMode" },
  ["niR"] = { "NORMAL r", "StalineNormalMode" },
  ["niV"] = { "NORMAL v", "StalineNormalMode" },
  ["no"] = { "N-PENDING", "StalineNormalMode" },
  ["i"] = { "INSERT", "StalineInsertMode" },
  ["ic"] = { "INSERT (completion)", "StalineInsertMode" },
  ["ix"] = { "INSERT completion", "StalineInsertMode" },
  ["t"] = { "TERMINAL", "StalineTerminalMode" },
  ["nt"] = { "NTERMINAL", "StalineNTerminalMode" },
  ["v"] = { "VISUAL", "StalineVisualMode" },
  ["V"] = { "V-LINE", "StalineVisualMode" },
  ["Vs"] = { "V-LINE (Ctrl O)", "StalineVisualMode" },
  [""] = { "V-BLOCK", "StalineVisualMode" },
  ["R"] = { "REPLACE", "StalineReplaceMode" },
  ["Rv"] = { "V-REPLACE", "StalineReplaceMode" },
  ["s"] = { "SELECT", "StalineSelectMode" },
  ["S"] = { "S-LINE", "StalineSelectMode" },
  [""] = { "S-BLOCK", "StalineSelectMode" },
  ["c"] = { "COMMAND", "StalineCommandMode" },
  ["cv"] = { "COMMAND", "StalineCommandMode" },
  ["ce"] = { "COMMAND", "StalineCommandMode" },
  ["r"] = { "PROMPT", "StalineConfirmMode" },
  ["rm"] = { "MORE", "StalineConfirmMode" },
  ["r?"] = { "CONFIRM", "StalineConfirmMode" },
  ["!"] = { "SHELL", "StalineTerminalMode" },
}


local M = function(m)
  local mode = api.nvim_get_mode().mode
  local sep = "%#" .. modes[mode][2] .. "Sep" .. "#" .. "  "
  local septwo = "%#StalineModeSepTwo" .. "#" .. " "
  if (m == 'minimal') then
    return "%#" .. modes[mode][2] .. "#" .. " " .. modes[mode][1] .. " ";
  elseif (m == 'fancy') then
    return "%#" .. modes[mode][2] .. "#" .. "  " .. modes[mode][1] .. " " .. sep .. septwo .. " ";
  elseif (m == 'monochrome') then
    return "%#" .. "StalineMonoMode" .. "#" .. " " .. modes[mode][1] .. " " .. "%#StalineEmptySpace#" .. " ";
  else
    return "F"
  end
end

return M
