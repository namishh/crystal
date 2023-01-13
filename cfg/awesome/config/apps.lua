local _M = {
  terminal = os.getenv('TERMINAL') or 'st',
  editor   = os.getenv('EDITOR') or 'nvim',
}

_M.editor_cmd = _M.terminal .. ' -e ' .. _M.editor
_M.manual_cmd = _M.terminal .. ' -e man awesome'

return _M
