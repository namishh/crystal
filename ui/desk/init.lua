-- I am pretty shit in stuff like this and this code probably 100% sucks
-- DISCLAIMER this is 400+ lines of mess and i will highly recommend you to stay away from this code
local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local inspect = require("modules.inspect")
local beautiful = require("beautiful")
local determine = require("ui.desk.determine")
local iconTheme = require("theme.colors").iconTheme
local widgets = require 'config.menu'
local json = require "modules.json"
local getIcon = require 'ui.dock.getIcon'

local desktop = {
  grid = wibox.widget { layout = wibox.layout.grid, forced_num_rows = 9, forced_num_cols = 20, orientation = 'horizontal' },
  objects = {},
  folders = {},
  files = {},
  generalstuff = {
    {
      name = "Trash",
      icon = iconTheme .. '/places/scalable/gnome-dev-trash-full.svg',
      type = "general",
      f = "nemo trash"
    }
  },
  shortcuts = {
  }
}
local DIR = '/home/namish/Desktop'
local grabber = {}

local DATA = gears.filesystem.get_cache_dir() .. 'data.json'

function desktop:getData()
  local f = assert(io.open(DATA, "rb"))
  local lines = f:read("*all")
  f:close()
  local data = json.decode(lines)
  return data
end

function desktop:writeData(d)
  os.execute('truncate -s 0 ' .. DATA)
  local f = assert(io.open(DATA, "a"))
  local write = json.encode(d)
  io.output(f)
  f:write(write)
  f:close()
end

function desktop:getStuff()
  local toAdd
  for path in io.popen("cd " .. DIR .. " && find . | tail -n +2"):lines() do
    path = string.sub(path, 3)
    if os.execute("cd '" .. DIR .. '/' .. path .. "'") then
      toAdd = {
        name = path,
        path = DIR .. "/" .. path,
        type = "folder",
        f = "nemo '" .. DIR .. "/" .. path .. "'",
        icon = iconTheme .. "places/scalable/stock_folder.svg"
      }
      table.insert(desktop.folders, toAdd)
    else
      local ext = path:match("^.+(%..+)$") or ' '
      if ext ~= '.desktop' then
        local s = determine(path, DIR .. '/')
        toAdd = {
          ext = ext,
          name = s.n,
          path = DIR .. "/" .. path,
          type = "file",
          f = s.fn,
          icon = iconTheme .. s.icon
        }
        table.insert(desktop.files, toAdd)
      else
        print("this si the line" .. path:sub(1, -8))
        toAdd = {
          name = path:gsub("^%l", string.upper):sub(1, -9),
          type = 'shortcut',
          icon = getIcon(nil, path:sub(1, -9), path:sub(1, -9), false),
          f = path:sub(1, -9),
        }
        table.insert(desktop.shortcuts, toAdd)
      end
    end
  end
  for _, entry in ipairs(desktop.generalstuff) do
    table.insert(desktop.objects, entry)
  end
  for _, entry in ipairs(desktop.folders) do
    table.insert(desktop.objects, entry)
  end
  for _, entry in ipairs(desktop.shortcuts) do
    table.insert(desktop.objects, entry)
  end
  for _, entry in ipairs(desktop.files) do
    table.insert(desktop.objects, entry)
  end
  self:writeData(desktop.objects)
end

function desktop:add(entry)
  local widget = wibox.widget {
    {
      {
        {
          id = "image_role",
          resize = true,
          align = 'center',
          forced_height = 50,
          forced_width = 50,
          image = entry.icon,
          widget = wibox.widget.imagebox,
        },
        widget = wibox.container.place,
        halign = 'center'
      },
      {
        {
          align = 'center',
          font = beautiful.font .. " 11",
          markup = entry.name,
          widget = wibox.widget.textbox,
        },
        widget = wibox.container.constraint,
        width = 70,
        height = 20,
      },
      spacing = 3,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    margins = 10,
    buttons = {
      awful.button({}, 1, function()
        awful.spawn.with_shell(entry.f)
      end),
      awful.button({}, 3, function()
        widgets.desktopMenu:toggle()
        widgets.mainmenu:toggle()
      end)

    },
  }
  desktop.grid:add(widget)
end

function desktop:start()
  local data = self:getData()
  for _, entry in ipairs(data) do
    desktop:add(entry)
  end
  local w = wibox({
    ontop = false,
    visible = true,
    x = 0,
    type = "dock",
    bg = beautiful.bg .. '00',
    y = beautiful.barSize + beautiful.useless_gap * 2,
    width = beautiful.scrwidth,
    height = beautiful.scrheight - beautiful.barSize - beautiful.dockSize * 2 - beautiful.useless_gap * 2,
  })
  awesome.connect_signal('toggle::desktop', function()
    w.visible = not w.visible
  end)
  w:setup {
    {
      self.grid,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    margins = 20,
    buttons = {
      awful.button({}, 3, function()
        widgets.mainmenu:toggle()
      end)
    },
  }
end

function grabber:init(finalWidget, fn, cl)
  local exclude = {
    "Shift_R",
    "Shift_L",
    "Tab",
    "Alt_R",
    "Alt_L",
    "Ctrl_L",
    "Ctrl_R",
    "CapsLock",
    "Home"
  }

  local function has_value(tab, val)
    for _, value in ipairs(tab) do
      if value == val then
        return true
      end
    end

    return false
  end
  grabber.main = awful.keygrabber({
    auto_start = true,
    stop_event = "release",
    keypressed_callback = function(_, _, key, _)
      local addition = ''
      if key == "Escape" or key == "Super_L" then
        grabber:stop()
        cl()
      elseif key == "BackSpace" then
        finalWidget:get_children_by_id('input')[1].markup = finalWidget:get_children_by_id('input')[1].markup:sub(1, -2)
      elseif key == "Return" then
        if string.len(finalWidget:get_children_by_id('input')[1].markup) > 0 then
          fn(finalWidget:get_children_by_id('input')[1].markup)
          finalWidget:get_children_by_id('input')[1].markup = ''
          grabber:stop()
        end
      elseif has_value(exclude, key) then
        addition = ''
      else
        addition = key
      end
      finalWidget:get_children_by_id('input')[1].markup = finalWidget:get_children_by_id('input')[1].markup .. addition
    end,
  })
end

function grabber:start()
  grabber.main:start()
end

function grabber:stop()
  grabber.main:stop()
end

function desktop:create(f)
  awful.screen.connect_for_each_screen(function(s)
    local pop = wibox({
      type = "dock",
      height = 100,
      width = 200,
      ontop = true,
      screen = s,
      visible = true,
      bg = beautiful.bg
    })
    awful.placement.centered(pop)
    local widget = wibox.widget {
      {
        font = beautiful.font .. " Light 12",
        markup = "Enter Name",
        valign = "center",
        align = "start",
        widget = wibox.widget.textbox,
      },
      {
        {
          {
            id = "input",
            font = beautiful.font .. " Light 12",
            markup = "",
            forced_height = 15,
            valign = "center",
            align = "start",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.margin,
          margins = 10
        },
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      spacing = 10,
      layout = wibox.layout.fixed.vertical
    }
    pop:setup {
      widget,
      widget = wibox.container.margin,
      margins = 10
    }
    grabber:init(widget, function(i)
      local toAdd
      if f == 'file' then
        s = determine(i, DIR .. '/')
        local ext = i:match('.') and i:match("^.+(%..+)$") or ''
        if ext ~= '.desktop' then
          toAdd = {
            ext = ext,
            name = s.n,
            path = DIR .. "/" .. i,
            type = "file",
            f = s.fn,
            icon = iconTheme .. s.icon
          }
        end
        table.insert(desktop.files, toAdd)
        awful.spawn.with_shell('touch ~/Desktop/"' .. i .. '"')
      elseif f == 'folder' then
        toAdd = {
          name = i,
          path = DIR .. "/" .. i,
          type = "folder",
          f = "nemo '" .. DIR .. "/" .. i .. "'",
          icon = iconTheme .. "places/scalable/stock_folder.svg"
        }
        awful.spawn.with_shell('mkdir -p ~/Desktop/"' .. i .. '"')
        table.insert(desktop.folders, toAdd)
      elseif f == 'shortcut' then
        local icon = getIcon(nil, i, i, false)
        toAdd = {
          name = i:gsub("^%l", string.upper),
          type = 'shortcut',
          icon = icon,
          f = i,
        }
        awful.spawn.with_shell('touch ~/Desktop/"' .. i .. '.desktop"')
        table.insert(desktop.shortcuts, toAdd)
      end
      desktop.objects = {}
      local stuff = { 'generalstuff', 'shortcuts', 'folders', 'files' }
      for _, k in ipairs(stuff) do
        for _, entry in ipairs(desktop[k]) do
          table.insert(desktop.objects, entry)
        end
      end
      desktop:writeData(desktop.objects)
      local new = desktop:getData()
      desktop.grid:reset()
      for _, entry in ipairs(new) do
        desktop:add(entry)
      end
      pop.visible = false
    end, function()
      pop.visible = false
    end)
    grabber:start()
  end)
end

awesome.connect_signal('create::something', function(f)
  desktop:create(f)
end)

desktop:getStuff()
desktop:start()
