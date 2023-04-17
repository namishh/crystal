local wibox = require("wibox")
local beautiful = require("beautiful")
local gears = require("gears")
local helpers = require("helpers")
local json = require("modules.json")
local awful = require("awful")

local schedule = {
  todoGrid = wibox.widget { layout = wibox.layout.grid, forced_num_cols = 1, orientation = 'horizontal' },
  doneGrid = wibox.widget { layout = wibox.layout.grid, forced_num_cols = 1, orientation = 'horizontal' },
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
                    end)
                  },
                },
                {
                  font = beautiful.icofont .. " 16",
                  markup = helpers.colorizeText("󰅖", beautiful.err),
                  valign = "center",
                  align = "start",
                  widget = wibox.widget.textbox,
                },
                spacing = 5,
                layout = wibox.layout.fixed.horizontal,
              },
              layout = wibox.layout.align.horizontal,
            },
            self.todoGrid,
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
            self.doneGrid,
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
    widget = wibox.container.margin,
    left = 20,
  }

  return self.widget
end

return schedule:init()
