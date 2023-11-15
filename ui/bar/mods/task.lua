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
local M          = {
  metadata = {
    {
      count = 0,
      pinned = true,
      icon = getIcon(nil, "firefox", "firefox"),
      id = 1,
      clients = {},
      class = "firefox",
      exec = "firefox",
      name = "firefox",
    },
    {
      count = 0,
      pinned = true,
      icon = getIcon(nil, "terminal", "terminal"),
      id = 2,
      clients = {},
      class = "org.wezfurlong.wezterm",
      exec = "wezterm",
      name = "wezterm",
    },
    {
      count = 0,
      pinned = true,
      icon = getIcon(nil, "discord", "discord"),
      id = 3,
      clients = {},
      class = "discord",
      exec = "discord",
      name = "discord",
    },
  },
  entries = {},
  classes = { "firefox", "org.wezfurlong.wezterm", "discord" }
}

M.widget         = wibox.widget {
  layout = layout,
  spacing = 10,
}

M.popupWidget    = wibox.widget {
  layout = wibox.layout.fixed.vertical,
  spacing = 10,
}

M.popup          = awful.popup {
  minimum_width = 240,
  widget        = wibox.container.background,
  visible       = false,
  shape         = helpers.rrect(5),
  ontop         = true,
  bg            = beautiful.bg
}

M.popup:setup {
  widget = wibox.container.margin,
  margins = 10,
  M.popupWidget,
}

local removeDup = function(arr)
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

function M:showMenu(data)
  local clients = data.clients
  self.popup.x = mouse.coords().x - 80
  self.popup.y = 1080 - 70 - (50 * (#clients + 2))
  self.popupWidget:reset()
  for i, j in ipairs(clients) do
    local widget = wibox.widget {
      {
        {
          {
            {
              markup = j.name,
              font   = beautiful.font .. " 12",
              height = 16,
              widget = wibox.widget.textbox,
            },
            widget = wibox.container.constraint,
            width = 180,
            height = 16,
          },
          nil,
          {
            markup  = helpers.colorizeText("󰅖", beautiful.red),
            font    = beautiful.icon .. " 16",
            widget  = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                j:kill()
                self.popup.visible = false
              end)
            },
          },
          layout = wibox.layout.align.horizontal
        },
        widget = wibox.container.margin,
        margins = 7,
      },
      buttons = {
        awful.button({}, 1, function()
          if j.minimized then
            j.minimized = false
            client.focus = j
          else
            j.minimized = true
          end
          self.popup.visible = false
        end)
      },
      widget = wibox.container.background,
      shape = helpers.rrect(4),
      bg = j.minimized and beautiful.fg .. '22' or beautiful.mbg
    }
    M.popupWidget:connect_signal("mouse::leave", function()
      self.popup.visible = false
    end)
    self.popupWidget:add(widget)
  end
  local addNew = wibox.widget {
    {
      {
        {
          {
            markup = "Open New Window",
            font   = beautiful.font .. " 12",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.constraint,
          width = 180,
        },
        nil,
        nil,
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.margin,
      margins = 7,
    },
    buttons = {
      awful.button({}, 1, function()
        awful.spawn.with_shell(data.exec)
      end)
    },
    widget = wibox.container.background,
    shape = helpers.rrect(4),
    bg = beautiful.mbg
  }
  local closeAll = wibox.widget {
    {
      {
        {
          {
            markup = "Close All",
            font   = beautiful.font .. " 12",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.constraint,
          width = 180,
        },
        nil,
        nil,
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.margin,
      margins = 7,
    },
    buttons = {
      awful.button({}, 1, function()
        for i, j in ipairs(clients) do
          j:kill()
        end
      end)
    },
    widget = wibox.container.background,
    shape = helpers.rrect(4),
    bg = beautiful.mbg
  }
  self.popupWidget:add(addNew)
  self.popupWidget:add(closeAll)
  self.popup.visible = true
end

function M:genMetadata()
  local clients = mouse.screen.selected_tag and mouse.screen.selected_tag:clients() or {}

  for _, j in pairs(self.metadata) do
    j.count = 0
    j.clients = {}
  end
  for _, c in ipairs(clients) do
    local icon = getIcon(c, c.class, c.class)
    local class = string.lower(c.class or "default")
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

local function getMinimized(clients)
  local a = 0
  for i, j in ipairs(clients) do
    if j.minimized then
      a = a + 1
    end
  end
  return a
end

function M:genIcons()
  self:genMetadata()
  self.widget:reset()
  print(inspect(self.metadata))
  for i, j in ipairs(self.metadata) do
    if j.pinned == true or j.count > 0 then
      local minimized = getMinimized(j.clients)
      local bg = beautiful.bg
      if client.focus then
        if client.focus.class:lower() == j.class then
          bg = beautiful.fg .. "22"
        elseif j.count > 0 then
          bg = beautiful.fg .. "55"
        end
      elseif minimized > 0 then
        bg = beautiful.fg .. "55"
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

      }
      widget:buttons(gears.table.join(
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
          else
            self:showMenu(j)
          end
        end),
        awful.button({}, 3, function()
          self:showMenu(j)
        end)
      ))
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
    M.popup.visible = false
  end
)
client.connect_signal(
  "unmanage",
  function()
    M:genIcons()
    M.popup.visible = false
  end
)
tag.connect_signal("property::selected", function()
  M:genIcons()
  M.popup.visible = false
end)
M:genIcons()

return M
