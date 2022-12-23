local M = function()
  if not vim.b.gitsigns_head or vim.b.gitsigns_git_status then
    return ""
  end

  local git_status = vim.b.gitsigns_status_dict

  local branch_name = "  " .. git_status.head .. " "

  return "%#StalineBranch#" .. branch_name
end

return M

