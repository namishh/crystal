local wibox = require("wibox")
local inspect = require("modules.inspect")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local json = require("modules.json")
local awful = require("awful")

local schedule = {
  todoGrid = wibox.widget { layout = wibox.layout.grid, forced_num_cols = 1, orientation = 'vertical', spacing = 10 },
  doneGrid = wibox.widget { layout = wibox.layout.grid, forced_num_cols = 1, orientation = 'vertical', spacing = 10 },
  data = {},
}

local DATA = gears.filesystem.get_cache_dir() .. 'schedule.json'
local check_exits = function(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

function schedule:getData()
  if check_exits(DATA) then
    local f = assert(io.open(DATA, "rb"))
    local lines = f:read("*all")
    f:close()
    local data = json.decode(lines)
    return data
  else
    return {}
  end
end

function schedule:writeData(d)
  os.execute('truncate -s 0 ' .. DATA)
  local f = assert(io.open(DATA, "wb"))
  local write = json.encode(d)
  f:write(write)
  f:flush()
  f:close()
end

function schedule:makeData(name, grid, id)
  local data = self:getData() or {}
  local isComp
  if grid == "todo" then
    isComp = false
  else
    isComp = true
  end
  local toAdd = {
    id = id,
    desc = name,
    completed = isComp
  }
  table.insert(data, toAdd)
  self:writeData(data)
end

function schedule:makeEntry(name, grid, id)
  local data = self:getData()
  local widget = wibox.widget {
    {
      {
        nil,
        {
          font = beautiful.font .. " 12",
          markup = name,
          widget = wibox.widget.textbox,
        },
        {
          {
            {
              font = beautiful.icofont .. " 16",
              markup = helpers.colorizeText(grid == "todo" and "󰄬" or "", beautiful.pri),
              valign = "center",
              align = "right",
              widget = wibox.widget.textbox,
              buttons = {
                awful.button({}, 1, function()
                  local newdata = data
                  local add
                  local index
                  for i, j in ipairs(data) do
                    if j.id == id then
                      add.id = j.id
                      add.desc = j.desc
                      add.completed = true
                      index = i
                    end
                  end
                  table.remove(newdata, index)
                  table.insert(newdata, add)
                  self:writeData(newdata)
                  self.todoGrid:reset()
                  self:getExisting()
                end)
              },
            },
            {
              font = beautiful.icofont .. " 16",
              markup = helpers.colorizeText("󰅖", beautiful.err),
              valign = "center",
              align = "right",
              widget = wibox.widget.textbox,
              buttons = {
                awful.button({}, 1, function()
                  local newdata = data
                  for i, j in ipairs(data) do
                    if j.id == id then
                      table.remove(newdata, i)
                    end
                  end
                  self:writeData(newdata)
                  self.todoGrid:reset()
                  self:getExisting()
                end)
              },
            },
            spacing = 5,
            layout = wibox.layout.fixed.horizontal,
          },
          widget = wibox.container.place,
          halign = 'right',
        },
        forced_height = 70,
        layout = wibox.layout.align.vertical
      },
      widget = wibox.container.margin,
      margins = 5,
    },
    forced_width = 280,
    widget = wibox.container.background,
    bg = beautiful.fg3 .. '33',
    shape = helpers.rrect(5)
  }
  if grid == "todo" then self.todoGrid:add(widget) else self.doneGrid:add(widget) end
end

function schedule:getExisting()
  local data = self:getData() or {}
  print(inspect(data))
  for _, i in ipairs(data) do
    print(inspect(i))
    if i.completed then
      self:makeEntry(i.desc, "completed")
    else
      self:makeEntry(i.desc, "todo")
    end
  end
end

function schedule:init()
  self.widget = wibox.widget {
    {
      {
        {
          {
            {
              {
                font = beautiful.font .. " 14",
                markup = "To be done",
                halign = "start",
                widget = wibox.widget.textbox,
              },
              nil,
              {
                {
                  font = beautiful.icofont .. " 16",
                  markup = helpers.colorizeText("󰐕", beautiful.pri),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                  buttons = {
                    awful.button({}, 1, function()
                      local id = helpers.generateId()
                      self:makeData("Never gonna give you up! Never gonna let you down", "todo", id)
                      self:makeEntry("Never gonna give you up! Never gonna let you down", "todo", id)
                    end)
                  },
                },
                {
                  font = beautiful.icofont .. " 16",
                  markup = helpers.colorizeText("󰅖", beautiful.err),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                  buttons = {
                    awful.button({}, 1, function()
                      self:makeData("Hello", "completed")
                      self:makeEntry("Hello", "completed")
                    end)
                  },
                },
                spacing = 5,
                layout = wibox.layout.fixed.horizontal,
              },
              layout = wibox.layout.align.horizontal,
            },
            {
              {

                self.todoGrid,
                scrollbar_width = 1.5,
                layout = require("modules.overflow").vertical
              },
              widget = wibox.container.margin,
              top = 7,
            },
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.margin,
          margins = 10,
        },
        shape = helpers.rrect(5),
        forced_width = 290,
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      {
        {
          {
            {
              {
                font = beautiful.font .. " 14",
                markup = "Completed",
                halign = "start",
                widget = wibox.widget.textbox,
              },
              nil,
              {
                font = beautiful.icofont .. " 16",
                markup = helpers.colorizeText("󰅖", beautiful.err),
                valign = "center",
                align = "start",
                widget = wibox.widget.textbox,
              },
              layout = wibox.layout.align.horizontal,

            },
            {
              {
                self.doneGrid,
                scrollbar_width = 1.5,
                layout = require("modules.overflow").vertical
              },
              widget = wibox.container.margin,
              top = 7,
            },
            layout = wibox.layout.fixed.vertical,
          },
          widget = wibox.container.margin,
          margins = 10,
        },
        forced_width = 290,
        shape = helpers.rrect(5),
        widget = wibox.container.background,
        bg = beautiful.mbg
      },
      spacing = 20,
      layout = wibox.layout.fixed.horizontal
    },
    forced_height = 200,
    widget = wibox.container.margin,
    left = 20,
  }

  return self.widget
end

schedule:getExisting()

return schedule:init()
