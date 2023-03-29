local _M = {}

local awful = require 'awful'

_M.layouts = {
  awful.layout.suit.spiral,
  awful.layout.suit.floating,
}

_M.tags = { '1', '2', '3', '4', '5' }

return _M
