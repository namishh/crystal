local wibox = require("wibox")
local gears = require("gears")
local inspect = require("modules.inspect")
local beautiful = require "beautiful"
local helpers = require "helpers"
local dpi = beautiful.xresources.apply_dpi

local filesystem = gears.filesystem
local icon_dir = filesystem.get_configuration_dir() .. "theme/icons/weather/"


local icon_map = {
  ["01d"] = "weather-clear-sky",
  ["02d"] = "weather-few-clouds",
  ["03d"] = "weather-clouds",
  ["04d"] = "weather-few-clouds",
  ["09d"] = "weather-showers-scattered",
  ["10d"] = "weather-showers",
  ["11d"] = "weather-strom",
  ["13d"] = "weather-snow",
  ["50d"] = "weather-fog",
  ["01n"] = "weather-clear-night",
  ["02n"] = "weather-few-clouds-night",
  ["03n"] = "weather-clouds-night",
  ["04n"] = "weather-clouds-night",
  ["09n"] = "weather-showers-scattered",
  ["10n"] = "weather-showers",
  ["11n"] = "weather-strom",
  ["13n"] = "weather-snow",
  ["50n"] = "weather-fog",
}


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

local dayWeather        = function()
  local widget = wibox.widget {
    {
      id = "day",
      halign = 'center',
      widget = wibox.widget.textbox,
      font = beautiful.font .. " 10",
    },
    {
      id = "icon",
      resize = true,
      opacity = 0.6,
      halign = 'center',
      forced_height = dpi(40),
      forced_width = dpi(40),
      widget = wibox.widget.imagebox,
    },
    {
      {
        {
          {
            id = "min",
            halign = 'center',
            widget = wibox.widget.textbox,
            font = beautiful.font .. " 10",
          },
          {
            halign = 'center',
            markup = helpers.colorizeText("/", beautiful.pri),
            widget = wibox.widget.textbox,
            font = beautiful.font .. " 10",
          },
          {
            id = "max",
            halign = 'center',
            widget = wibox.widget.textbox,
            font = beautiful.font .. " 10",
          },
          spacing = 8,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.place,
        halign = 'center',
      },
      widget = wibox.container.margin,
      bottom = 8,
    },
    spacing = 10,
    forced_width = 80,
    layout = wibox.layout.fixed.vertical,
  }

  widget.update = function(out, i)
    local day = out.daily[i]
    widget:get_children_by_id('icon')[1].image = icon_dir .. icon_map[day.weather[1].icon] .. ".svg"
    widget:get_children_by_id('day')[1].text = os.date("%a", tonumber(day.dt))
    local getTemp = function(temp)
      local sp = helpers.split(temp, '.')[1]
      return sp
    end
    widget:get_children_by_id('min')[1].text = getTemp(day.temp.night)
    widget:get_children_by_id('max')[1].text = getTemp(day.temp.day)
    print(inspect(out))
  end
  return widget
end

local day1              = dayWeather()
local day2              = dayWeather()
local day3              = dayWeather()
local day5              = dayWeather()
local day6              = dayWeather()
local day4              = dayWeather()

local daylist           = { day1, day2, day3, day4, day5, day6 }

local widget            = wibox.widget {
  {
    {
      {
        {
          {
            {
              id = "weathericon",
              forced_height = dpi(70),
              halign = 'center',
              forced_width = dpi(70),
              widget = wibox.widget.imagebox
            },
            {
              id = "desc",
              halign = 'center',
              widget = wibox.widget.textbox,
              font = beautiful.font .. " 14",
              markup = helpers.colorizeText("Hello", beautiful.pri)
            },
            spacing = 8,
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
          font = beautiful.font .. " 26",
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
    {
      day1,
      day2,
      day3,
      day4,
      day5,
      day6,
      spacing = 20,
      layout = require("modules.overflow").horizontal,
      scrollbar_width = dpi(3),
    },
    spacing = 20,
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
  for i, j in ipairs(daylist) do
    j.update(out, i)
  end
end)

return widget
