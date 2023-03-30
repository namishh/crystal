local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local helpers = require("helpers")
local Gio = require("lgi").Gio

local appMenu = {}

local highlight = function(grid)
  local i = 0
  local widget
  while true do
    i = i + 1
    widget = grid:get_widgets_at(i,1)
    if not widget then break end
  end
end

local generate = function (grid)
  grid:reset() -- make the grid empty again
  for i, entry in ipairs(appMenu.apps) do
    local widget = {
      font = beautiful.font .. " 11",
      markup = helpers.colorizeText(entry.name, beautiful.fg3),
      widget = wibox.widget.textbox,
    }
    grid:add(widget)
  end
  if appMenu.index > #appMenu.apps then
    appMenu.index = #appMenu.apps
  elseif module.index < 1 then
    module.index = 1
  end
  collectgarbage()
end

appMenu.open = function()
  appMenu.apps = {}
  appMenu.start = 1
  appMenu.index = 1
  local allApps = Gio.AppInfo.get_all()
  local grid = wibox.widget{layout = wibox.layout.grid, forced_num_cols = 1,}
  for i,entry in ipairs(allApps) do
    totalApps = totalApps + 1
    local name = entry:get_name():gsub('&', "&amp;"):gsub('<', "&lt;"):gsub("'", '&#39;')
    table.insert( appMenu.apps, {name = name, appinfo = entry, index=i})
  end
  local popup = awful.popup {
      shape = helpers.rrect(7),
      placement = awful.placement.centered,
      ontop = true,
      visible = true,
      widget = {
        {
          grid,
          {
            id = "search",
            widget = wibox.widget.textbox
          },
          layout = wibox.layout.fixed.vertical
        },
        widget = wibox.container.margin,
        margins = 20,
      },
  }
  generate(grid)
end

--appMenu.open()