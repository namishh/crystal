local cmd = vim.api.nvim_command

local function autocmd(this, event, spec)
  local is_table = type(spec) == 'table'
  local pattern = is_table and spec[1] or '*'
  local action = is_table and spec[2] or spec
  if type(action) == 'function' then
    action = this.set(action)
  end
  local e = type(event) == 'table' and table.concat(event, ',') or event
  cmd('autocmd ' .. e .. ' ' .. pattern .. ' ' .. action)
end

local N = {
  __au = {}
}

local M = setmetatable({}, {
  __index = N,
  __newindex = autocmd,
  __call = autocmd,
})

N.exec = function(id)
  M.__au[id]()
end

N.set = function(fn)
  local id = string.format('%p', fn)
  M.__au[id] = fn
  return string.format('lua require("core.autocmds").exec("%s")', id)
end

N.group = function(grp, cmds)
  cmd('augroup ' .. grp)
  cmd('autocmd!')
  if type(cmds) == 'function' then
    cmds(M)
  else
    for _, au in ipairs(cmds) do
      autocmd(N, au[1], { au[2], au[3] })
    end
  end
  cmd('augroup END')
end

return M
