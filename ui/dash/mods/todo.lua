local gears = require("gears")
local json = require "mods.json"
local wibox = require("wibox")
local awful = require("awful")
local beautiful = require("beautiful")
local helpers = require("helpers")

local DATA = gears.filesystem.get_cache_dir() .. 'json/todos.json'

local elems = wibox.widget {
  layout = require("mods.overflow").vertical,
  scrollbar_enabled = false,
  forced_height = 300,
}

local check_exits = function(path)
  local file = io.open(path, "rb")
  if file then file:close() end
  return file ~= nil
end

local getData = function()
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

local writeData = function(d)
  os.execute('truncate -s 0 ' .. DATA)
  local f = assert(io.open(DATA, "wb"))
  local write = json.encode(d)
  f:write(write)
  f:flush()
  f:close()
end

local grabber = {}
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

local function getPop(tit)
  local pop = wibox({
    type = "dock",
    height = 90,
    width = 400,
    ontop = true,
    visible = true,
    bg = beautiful.bg
  })
  awful.placement.centered(pop)
  local widget = wibox.widget {
    {
      font = beautiful.sans .. " 12",
      markup = tit,
      valign = "center",
      align = "start",
      widget = wibox.widget.textbox,
    },
    {
      {
        {
          id = "input",
          font = beautiful.sans .. " 12",
          markup = "",
          forced_height = 18,
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

local function makeElement(i, n)
  awful.screen.connect_for_each_screen(function(s)
    local widget = wibox.widget {
      {
        {
          {
            id = "input",
            font = beautiful.sans .. " 14",
            markup = i.completed and "<s>" .. i.name .. "</s>" or i.name,
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
          },
          widget = wibox.container.constraint,
          width = 300,
        },
        nil,
        {
          {
            font = beautiful.icon .. " 16",
            markup = helpers.colorizeText("󰸞", beautiful.green),
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                local new = {
                  completed = not i.completed,
                  name = i.name
                }
                local data = getData()
                table.remove(data, n)
                table.insert(data, n, new)
                writeData(data)
                elems:reset()
                for k, l in ipairs(data) do
                  makeElement(l, k)
                end
              end),
            },
          },
          {
            font = beautiful.icon .. " 16",
            markup = helpers.colorizeText("󰩹", beautiful.red),
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                local data = getData()
                table.remove(data, n)
                writeData(data)
                elems:reset()
                for k, l in ipairs(data) do
                  makeElement(l, k)
                end
              end),
            },
          },
          spacing = 18,
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
      },
      widget = wibox.container.background,
      forced_height = 45,
      forced_width = 400,
      data = i
    }
    widget:get_children_by_id('input')[1]:add_button(awful.button({}, 1, function()
      local w, pop = getPop('Enter New Name')
      grabber:init(w, function(string)
        pop.visible = false
        local new = {
          completed = i.completed,
          name = string
        }
        local data = getData()
        table.remove(data, n)
        table.insert(data, n, new)
        writeData(data)
        elems:reset()
        for k, l in ipairs(data) do
          makeElement(l, k)
        end
      end, function()
        pop.visible = false
      end)
      grabber:start()
    end))
    elems:add(widget)
  end)
end

local makeData = function(d)
  local data = getData()
  table.insert(data, d)
  writeData(data)
end

local function refresh()
  elems:reset()
  local data = getData()
  for i, j in ipairs(data) do
    makeElement(j, i)
  end
end

local empV

local finalwidget = wibox.widget {
  {
    {
      {
        {
          font = beautiful.sans .. " 14",
          markup = "To-Dos",
          valign = "center",
          align = "center",
          widget = wibox.widget.textbox,
        },
        nil,
        {
          {
            font = beautiful.icon .. " 20",
            markup = helpers.colorizeText("󰐕", beautiful.blue),
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                local data = {
                  completed = false,
                  name = "New Todo! Click to change name"
                }
                makeData(data)
                refresh()
              end),
            },
          },
          {
            font = beautiful.icon .. " 20",
            markup = helpers.colorizeText("󰅖", beautiful.red),
            valign = "center",
            align = "center",
            widget = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                os.execute("rm " .. DATA)
                refresh()
              end),
            },
          },
          spacing = 20,
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
      },
      {
        elems,
        widget = wibox.container.place,
        valign = 'top'
      },
      spacing = 18,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
    margins = 18
  },
  forced_width = 460,
  shape = helpers.rrect(8),
  widget = wibox.container.background,
  bg = beautiful.mbg
}

refresh()
return finalwidget
