local awful      = require("awful")
local dpi        = require("beautiful").xresources.apply_dpi
local wibox      = require("wibox")
local gears      = require("gears")
local Gio        = require("lgi").Gio
local helpers    = require("helpers")
local beautiful  = require("beautiful")
local getIcon    = require("mods.getIcon")

local layout     = wibox.layout.fixed.horizontal
local flexlayout = wibox.layout.flex.horizontal

local inspect    = require("mods.inspect")
local M          = { metadata = {}, entries = {}, classes = {} }

M.widget         = wibox.widget {
  layout = layout,
  spacing = 10,
}

local removeDup  = function(arr)
  local hash = {}
  local res = {}

  for _, v in ipairs(arr) do
    if (not hash[v]) then
      res[#res + 1] = v -- you could print here instead of saving to result table if you wanted
      hash[v] = true
    end
  end

  return res
end


function M:getExecutable(class)
  local class_1 = class:gsub("[%-]", "")
  local class_2 = class:gsub("[%-]", ".")

  local class_3 = class:match("(.-)-") or class
  class_3 = class_3:match("(.-)%.") or class_3
  class_3 = class_3:match("(.-)%s+") or class_3
  local apps = Gio.AppInfo.get_all()
  local possible_icon_names = { class, class_3, class_2, class_1 }
  for _, app in ipairs(apps) do
    local id = app:get_id():lower()
    for _, possible_icon_name in ipairs(possible_icon_names) do
      if id and id:find(possible_icon_name, 1, true) then
        return app:get_executable()
      end
    end
  end
  return class:lower()
end

function M:genMetadata()
  local clients = mouse.screen.selected_tag and mouse.screen.selected_tag:clients() or {}

  for _, j in pairs(self.metadata) do
    j.count = 0
    j.clients = {}
  end
  for _, c in ipairs(clients) do
    local icon = getIcon(c, c.class, c.class)
    local class = string.lower(c.class)
    local exe = self:getExecutable(c.class)
    if helpers.inTable(self.classes, class) then
      for _, j in pairs(self.metadata) do
        if j.class:lower() == class:lower() then
          table.insert(j.clients, c)
          j.count = j.count + 1
        end
      end
    else
      table.insert(self.classes, class)
      local toInsert = {
        count = 1,
        pinned = false,
        icon = icon,
        id = #self.classes + 1,
        clients = { c },
        class = class,
        exec = exe,
        name = c.name,
      }
      table.insert(self.metadata, toInsert)
    end
    for _, j in pairs(self.metadata) do
      j.clients = removeDup(j.clients)
    end
  end
  table.sort(self.metadata, function(a, b) return a.id < b.id end)
end

function M:genIcons()
  self:genMetadata()
  self.widget:reset()
  print(inspect(self.metadata))
  for i, j in ipairs(self.metadata) do
    if j.pinned == true or j.count > 0 then
      local bg = beautiful.bg
      if client.focus then
        if client.focus.class:lower() == j.class then
          bg = beautiful.fg2 .. "33"
        end
      end
      local widget = wibox.widget {
        {
          {
            widget = wibox.widget.imagebox,
            image = j.icon,
            forced_height = 35,
            forced_width = 35,
            clip_shape = helpers.rrect(100),
            resize = true,
          },
          widget = wibox.container.margin,
          margins = 3,
        },
        shape = helpers.rrect(10),
        widget = wibox.container.background,
        bg = bg,
        buttons = {
          awful.button({}, 1, function()
            if j.count == 0 then
              awful.spawn.with_shell(j.exec)
            elseif j.count == 1 then
              if j.clients[j.count].minimized then
                j.clients[j.count].minimized = false
                client.focus = j.clients[j.count]
              else
                j.clients[j.count].minimized = true
              end
            end
          end)
        },

      }
      self.widget:add(widget)
    end
  end
end

client.connect_signal(
  "focus",
  function()
    M:genIcons()
  end
)
client.connect_signal(
  "property::minimized",
  function()
    M:genIcons()
  end
)
client.connect_signal(
  "property::maximized",
  function()
    M:genIcons()
  end
)
client.connect_signal(
  "manage",
  function()
    M:genIcons()
  end
)
client.connect_signal(
  "unmanage",
  function()
    M:genIcons()
  end
)
tag.connect_signal("property::selected", function() M:genIcons() end)
M:genIcons()

return M
