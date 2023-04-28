local wibox = require("wibox")
local awful = require("awful")
local beautiful = require "beautiful"
local helpers = require "helpers"
local dpi = beautiful.xresources.apply_dpi


local createWeatherProg = function()
  local widget = wibox.widget {
    {
      {
        id               = "prog",
        max_value        = 50,
        min_value        = 0,
        value            = 10,
        shape            = helpers.rrect(6),
        bar_shape        = helpers.rrect(6),
        color            = beautiful.pri,
        background_color = beautiful.bg,
        widget           = wibox.widget.progressbar,
      },
      forced_height = 100,
      forced_width  = 15,
      direction     = 'east',
      layout        = wibox.container.rotate,
    },
    {
      id = "time",
      halign = 'center',
      widget = wibox.widget.textbox,
      font = beautiful.font .. " 10",
    },
    spacing = 5,
    layout = wibox.layout.fixed.vertical
  }
  return widget
end

local hour1             = createWeatherProg()
local hour2             = createWeatherProg()
local hour3             = createWeatherProg()
local hour4             = createWeatherProg()
local hour5             = createWeatherProg()
local hour6             = createWeatherProg()

local hourList          = { hour1, hour2, hour3, hour4, hour5, hour6 }

local widget            = wibox.widget {
  {
    {
      {
        {
          {
            {
              id = "weathericon",
              forced_height = dpi(90),
              halign = 'center',
              forced_width = dpi(90),
              widget = wibox.widget.imagebox
            },
            {
              id = "desc",
              halign = 'center',
              widget = wibox.widget.textbox,
              font = beautiful.font .. " 14",
              markup = helpers.colorizeText("Hello", beautiful.pri)
            },
            spacing = 15,
            layout = wibox.layout.fixed.vertical
          },
          widget = wibox.container.place,
          halign = 'center'
        },
        widget = wibox.container.background,
        forced_width = 225,
      },
      {
        {
          id = "temp",
          halign = 'center',
          widget = wibox.widget.textbox,
          font = beautiful.font .. " 34",
          markup = helpers.colorizeText("Hello", beautiful.pri)
        },
        {
          id = "feels",
          halign = 'center',
          widget = wibox.widget.textbox,
          font = beautiful.font .. " 13",
          markup = helpers.colorizeText("Feels like", beautiful.pri)
        },
        {
          {
            id = "humid",
            halign = 'center',
            widget = wibox.widget.textbox,
            font = beautiful.font .. " 11",
            markup = helpers.colorizeText("Humidity", beautiful.pri)
          },
          widget = wibox.container.margin,
          top = 12,
        },
        spacing = 8,
        layout = wibox.layout.fixed.vertical
      },
      layout = wibox.layout.fixed.horizontal
    },
    {

      {
        {
          {
            {
              {
                valign = 'top',
                widget = wibox.widget.textbox,
                font = beautiful.font .. " 10",
                markup = "50"
              },
              {
                valign = 'center',
                widget = wibox.widget.textbox,
                font = beautiful.font .. " 10",
                markup = "25"
              },
              {
                valign = 'center',
                widget = wibox.widget.textbox,
                font = beautiful.font .. " 10",
                markup = "0"
              },
              layout = wibox.layout.align.vertical
            },
            widget = wibox.container.background,
            forced_height = 80,
          },
          widget = wibox.container.margin,
          right = 8,
          bottom = 15,
        },
        hour1,
        hour2,
        hour3,
        hour4,
        hour5,
        hour6,
        spacing = 20,
        layout = wibox.layout.fixed.horizontal
      },
      widget = wibox.container.place,
      halign = 'center'
    },
    spacing = 15,
    layout = wibox.layout.fixed.vertical,
  },
  widget = wibox.container.margin,
  margins = 5,
}


awesome.connect_signal("connect::weather", function(out)
  widget:get_children_by_id('weathericon')[1].image = out.image
  widget:get_children_by_id('desc')[1].markup = helpers.colorizeText(string.lower(out.desc), beautiful.pri)
  widget:get_children_by_id('temp')[1].markup = helpers.colorizeText(out.temp .. "°C", beautiful.pri)
  widget:get_children_by_id('feels')[1].markup = "Feels like " .. out.feelsLike .. "°C"
  widget:get_children_by_id('humid')[1].markup = "Humidity: " .. out.humidity .. "%"
  for i, j in ipairs(hourList) do
    j:get_children_by_id("prog")[1].value = out.hourly[i].temp
    j:get_children_by_id("time")[1].markup = os.date("%Hh", tonumber(out.hourly[i].dt))
  end
end)

return widget
