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

-- so this is the main desktop object
local desktop = {
  grid = wibox.widget { layout = wibox.layout.grid, forced_num_rows = 9, forced_num_cols = 20, orientation = 'horizontal' },
  objects = {},
  folders = {},
  files = {},
  generalstuff = { -- use this to add xdg stuff like trashcan and home folder, etc
    {
      name = "Trash",
      icon = iconTheme .. '/places/scalable/gnome-dev-trash-full.svg',
      type = "generalstuff",
      f = "nemo trash:/"
    }
  },
  shortcuts = {},
  toChange = {},
}
local DIR = '/home/namish/Desktop'
local grabber = {} -- a general class for a grabber

local DATA = gears.filesystem.get_cache_dir() .. 'data.json'

desktop.menu = awful.menu {
  items = {
    { 'Remove',      function() awesome.emit_signal('remove::something', desktop.toChange) end },
    { 'Change Icon', function() awesome.emit_signal('edit::icon', desktop.toChange) end },
    { 'Rename',      function() awesome.emit_signal('edit::name', desktop.toChange) end }
  }
}

-- this function reads the data in the json file as a string and decodes it into a table form for us perform operations
function desktop:getData()
  local f = assert(io.open(DATA, "rb"))
  local lines = f:read("*all")
  f:close()
  local data = json.decode(lines)
  return data
end

-- and this function takes an object
-- first it clears the data file, and then encodes the given object and then wrties to that cleared file
function desktop:writeData(d)
  os.execute('truncate -s 0 ' .. DATA)
  local f = assert(io.open(DATA, "a"))
  local write = json.encode(d)
  io.output(f)
  f:write(write)
  f:close()
end

function desktop:getStuff(again)
  local toAdd
  local data = self:getData() or {}
  -- this loops over all the files in the Desktop directory
  for path in io.popen("cd " .. DIR .. " && find . | tail -n +2"):lines() do
    path = string.sub(path, 3)
    local match = {}
    for _, v in ipairs(data) do
      if v.path == DIR .. "/" .. path then
        match = v
      end
    end


    -- if the `cd` command is successful then it is a folder
    if os.execute("cd '" .. DIR .. '/' .. path .. "'") then
      toAdd = {
        name = path,
        path = DIR .. "/" .. path,
        type = "folder",
        f = "nemo '" .. DIR .. "/" .. path .. "'",
        icon = iconTheme .. "places/scalable/stock_folder.svg"
      }
      if again then
        if not next(match) then table.insert(self.folders, toAdd) end
      else
        table.insert(self.folders, toAdd)
      end
    else -- else it is a file
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
        if again then
          if not next(match) then table.insert(self.files, toAdd) end
        else
          table.insert(self.files, toAdd)
        end
      else -- desktop shortcuts are special
        toAdd = {
          name = match.name ~= '' and match.name or path:gsub("^%l", string.upper):sub(1, -9),
          type = 'shortcut',
          path = match.path ~= '' and match.path or DIR .. "/" .. path,
          icon = match.icon ~= '' and match.icon or getIcon(nil, path:sub(1, -9), path:sub(1, -9), false),
          f = match.f ~= '' and match.f or path:sub(1, -9),
        }
        if again then
          if not next(match) then table.insert(self.shortcuts, toAdd) end
        else
          table.insert(self.shortcuts, toAdd)
        end
      end
    end
  end
  local stuff = { 'generalstuff', 'shortcuts', 'folders', 'files' }
  for _, k in ipairs(stuff) do
    for _, e in ipairs(desktop[k]) do
      table.insert(desktop.objects, e)
    end
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
        widgets.mainmenu:toggle()
        self.toChange = entry
        self.menu:toggle()
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

function desktop:refresh()
  desktop.objects = {}
  local stuff = { 'generalstuff', 'shortcuts', 'folders', 'files' }
  for _, k in ipairs(stuff) do
    for _, e in ipairs(desktop[k]) do
      table.insert(desktop.objects, e)
    end
  end
  desktop:writeData(desktop.objects)
  local new = desktop:getData()
  desktop.grid:reset()
  for _, e in ipairs(new) do
    desktop:add(e)
  end
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

local indexOf = function(array, value)
  for i, v in ipairs(array) do
    if v == value then
      return i
    end
  end
  return nil
end

local getList = function(entry)
  local list
  if entry.type == "file" then
    list = desktop.files
  elseif entry.type == "folder" then
    list = desktop.folders
  elseif entry.type == "shortcut" then
    list = desktop.shortcuts
  elseif entry.type == "generalstuff" then
    list = desktop.generalstuff
  end
  return list
end

function desktop:remove(entry, per)
  if per then
    if entry.type == 'folder' then
      os.execute('rm -rf "' .. entry.path .. '"')
    else
      os.execute('rm "' .. entry.path .. '"')
    end
  end
  local list = getList(entry)
  local index = indexOf(list, entry)
  table.remove(list, index)
  self:refresh()
end

awesome.connect_signal('remove::something', function(entry)
  desktop:remove(entry, true)
end)

function desktop:getPop(tit, s)
  local pop = wibox({
    type = "dock",
    height = 90,
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
      markup = tit,
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
  return widget, pop
end

function desktop:changeIcon(e)
  awful.screen.connect_for_each_screen(function(s)
    local widget, pop = self:getPop('Change Icon to: ', s)
    grabber:init(widget, function(i)
      local icon = getIcon(nil, i, i, false)
      pop.visible = false
      self:remove(e, false)
      local toAdd = {
        path = e.path,
        name = e.name,
        type = e.type,
        f = e.f,
        icon = icon,
      }
      local list = getList(e)
      table.insert(list, toAdd)
      print(inspect(list))
      print(inspect(toAdd))
      self:refresh()
    end, function()
      pop.visible = false
    end)
    grabber:start()
  end)
end

function desktop:changeName(e)
  awful.screen.connect_for_each_screen(function(s)
    local widget, pop = self:getPop('Change Name to: ', s)
    grabber:init(widget, function(i)
      pop.visible = false
      self:remove(e, false)
      local toAdd = {
        path = e.path,
        name = i,
        type = e.type,
        f = e.f,
        icon = e.icon,
      }
      if e.type == 'shortcut' then
        os.execute('mv ' .. DIR .. '/"' .. string.lower(e.name) .. '.desktop" ' .. DIR .. '/"' .. i .. '.desktop"')
      else
        if e.type == 'file' then
          local a = determine(i, DIR .. '/')
          toAdd.icon = iconTheme .. a.icon
        end
        os.execute('mv ' .. DIR .. '/"' .. e.name .. '" ' .. DIR .. '/"' .. i .. '"')
      end
      local list = getList(e)
      table.insert(list, toAdd)
      self:refresh()
    end, function()
      pop.visible = false
    end)
    grabber:start()
  end)
end

function desktop:create(f)
  awful.screen.connect_for_each_screen(function(s)
    local pop = wibox({
      type = "dock",
      height = 90,
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
      if f == 'file' then
        i = i or "Untitled File"
        s = determine(i, DIR .. '/')
        local ext = i:match('.') and i:match("^.+(%..+)$") or ''
        if ext ~= '.desktop' then
          awful.spawn.with_shell('touch ~/Desktop/"' .. i .. '"')
        end
      elseif f == 'folder' then
        awful.spawn.with_shell('mkdir -p ~/Desktop/"' .. i .. '"')
      elseif f == 'shortcut' then
        if i then
          awful.spawn.with_shell('touch ~/Desktop/"' .. i .. '.desktop"')
        end
      end
      self:refresh()
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


awesome.connect_signal('desktop::refresh', function()
  desktop:getStuff(true)
  desktop:refresh()
end)

awesome.connect_signal('edit::icon', function(entry)
  desktop:changeIcon(entry)
end)

awesome.connect_signal('edit::name', function(entry)
  desktop:changeName(entry)
end)
desktop:getStuff(false)
desktop:start()

local subscribe = [[
   bash -c "
   while (inotifywait -r -e close_write -e delete -e modify -e create -e move $HOME/Desktop/ -qq) do echo; done
"]]

awful.spawn.easy_async_with_shell(
  "ps x | grep \"inotifywait -e close_write -e delete -e create -e modify -e move $HOME/Desktop/\" | grep -v grep | awk '{print $1}' | xargs kill",
  function()
    awful.spawn.with_line_callback(subscribe, {
      stdout = function(_)
        awesome.emit_signal("desktop::refresh")
      end
    })
  end)
