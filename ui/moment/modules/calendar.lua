local wibox = require("wibox")
local awful = require("awful")
local beautiful = require "beautiful"
local helpers = require "helpers"
local dpi = beautiful.xresources.apply_dpi

local datewidget = function(date, weekend)
  weekend = weekend or false
  return wibox.widget {
    markup = weekend and helpers.colorizeText(date, beautiful.fg3) or date,
    halign = 'center',
    font   = beautiful.font .. " 13",

    widget = wibox.widget.textbox
  }
end

local daywidget = function(day, weekend)
  weekend = weekend or false
  return wibox.widget {
    markup = weekend and helpers.colorizeText(day, beautiful.err) or day,
    halign = 'center',
    font   = beautiful.font .. " 14",
    widget = wibox.widget.textbox
  }
end
local currwidget = function(day)
  return wibox.widget {
    markup = helpers.colorizeText(day, beautiful.pri),
    halign = 'center',
    font   = beautiful.font .. " 13",
    widget = wibox.widget.textbox
  }
end

local title = wibox.widget {
  font = beautiful.font .. " Bold 14",
  widget = wibox.widget.textbox
}

local theGrid = wibox.widget {
  forced_num_rows = 7,
  forced_num_cols = 7,
  vertical_spacing = dpi(10),
  horizontal_spacing = dpi(15),
  min_cols_size = dpi(30),
  min_rows_size = dpi(30),
  homogenous = true,
  layout = wibox.layout.grid,
}

local curr

local updateCalendar = function(date)
  title.text = os.date("%B %Y", os.time(date))
  theGrid:reset()
  for _, w in ipairs { "Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat" } do
    if w == "Sun" or w == "Sat" then
      theGrid:add(daywidget(w, true))
    else
      theGrid:add(daywidget(w, false))
    end
  end
  local firstDate = os.date("*t", os.time({ day = 1, month = date.month, year = date.year }))
  local lastDate = os.date("*t", os.time({ day = 0, month = date.month + 1, year = date.year }))

  local row = 2
  local col = firstDate.wday

  for day = 1, lastDate.day do
    if day == date.day then
      theGrid:add_widget_at(currwidget(day), row, col)
    elseif col == 1 or col == 7 then
      theGrid:add_widget_at(datewidget(day, true), row, col)
    else
      theGrid:add_widget_at(datewidget(day, false), row, col)
    end

    if col == 7 then
      col = 1
      row = row + 1
    else
      col = col + 1
    end
  end
end

return function()
  curr = os.date("*t")
  updateCalendar(curr)
  return wibox.widget {
    {
      {
        {
          {
            {
              {
                font = beautiful.font .. " 32",
                format = "%I",
                align = "center",
                valign = "center",
                widget = wibox.widget.textclock
              },
              {
                markup = helpers.colorizeText(":", beautiful.pri),
                font = beautiful.font .. " 32",
                widget = wibox.widget.textbox,
              },
              {
                font = beautiful.font .. " 32",
                format = "%M",
                align = "center",
                valign = "center",
                widget = wibox.widget.textclock
              },
              layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.place,
            halign = 'center'
          },
          widget = wibox.container.margin,
          bottom = 6,
        },
        {
          title,
          nil,
          {
            {
              text = "󰁍",
              font = beautiful.icofont,
              widget = wibox.widget.textbox,
              buttons = awful.button({}, 1, function()
                curr = os.date("*t", os.time({
                  day = curr.day,
                  month = curr.month - 1,
                  year = curr.year
                }))
                updateCalendar(curr)
              end)
            },
            {
              text = "󰁔",
              font = beautiful.icofont,
              widget = wibox.widget.textbox,
              buttons = awful.button({}, 1, function()
                curr = os.date("*t", os.time({
                  day = curr.day,
                  month = curr.month + 1,
                  year = curr.year
                }))
                updateCalendar(curr)
              end)
            },
            spacing = 10,
            layout = wibox.layout.fixed.horizontal
          },
          layout = wibox.layout.align.horizontal
        },
        theGrid,
        layout = wibox.layout.fixed.vertical
      },
      widget = wibox.container.margin,
      margins = 5
    },
    shape = helpers.rrect(10),
    widget = wibox.container.background,
    bg = beautiful.bg,
  }
end
