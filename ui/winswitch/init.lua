local awful = require("awful")
local dpi = require('beautiful').xresources.apply_dpi
local gears = require('gears')
local wibox = require('wibox')

return function()
  local curr = 0
  local wins = wibox.widget {
    spacing = dpi(20),
    layout = wibox.layout.fixed.horizontal,
    id = "switcher"
  }

  local function createWin(fn)
    fn = fn or ''
    wins:reset()
    -- this way the focused client is the first and after that we get the other clients
    local clients = mouse.screen.selected_tag:clients()
    local clientsSorted = {}
    if client.focus then
      clientsSorted[1] = client.focus
    end
    for _, client in ipairs(clients) do
      if client ~= clientsSorted[1] then
        table.insert(clientsSorted, client)
      end
    end

    curr = curr

    for _, client in clientsSorted do
      local widget = wibox.widget {

      }
    end
  end
end
