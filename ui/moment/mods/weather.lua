local wibox      = require("wibox")
local awful      = require("awful")
local beautiful  = require "beautiful"
local gears      = require("gears")
local helpers    = require "helpers"

local filesystem = gears.filesystem
local icon_dir   = filesystem.get_configuration_dir() .. "theme/assets/weather/icons/"


local icon_map   = {
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

local dayWeather = function()
  local widget = wibox.widget {
    {
      id = "day",
      halign = 'center',
      widget = wibox.widget.textbox,
      font = beautiful.sans .. " 10",
    },
    {
      id = "icon",
      resize = true,
      opacity = 0.6,
      halign = 'center',
      forced_height = 40,
      forced_width = 40,
      widget = wibox.widget.imagebox,
    },
    {
      {
        {
          {
            id = "max",
            halign = 'center',
            widget = wibox.widget.textbox,
            font = beautiful.sans .. " 10",
          },
          {
            halign = 'center',
            markup = helpers.colorizeText("/", beautiful.blue),
            widget = wibox.widget.textbox,
            font = beautiful.sans .. " 10",
          },
          {
            id = "min",
            halign = 'center',
            widget = wibox.widget.textbox,
            font = beautiful.sans .. " 10",
          },
          spacing = 8,
          layout = wibox.layout.fixed.horizontal,
        },
        widget = wibox.container.place,
        halign = 'center',
      },
      widget = wibox.container.margin,
      bottom = 20,
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
  end
  return widget
end

local day1       = dayWeather()
local day2       = dayWeather()
local day3       = dayWeather()
local day5       = dayWeather()
local day6       = dayWeather()
local day4       = dayWeather()

local daylist    = { day1, day2, day3, day4, day5, day6 }


local widget = wibox.widget {
  {
    id = "image",
    forced_height = 300,
    forced_width = 460,
    image = helpers.cropSurface(1.53, gears.surface.load_uncached(beautiful.songdefpicture)),
    widget = wibox.widget.imagebox,
    clip_shape = helpers.rrect(12),
    opacity = 0.9,
    resize = true,
    horizontal_fit_policy = "fit"
  },
  {
    {
      widget = wibox.widget.textbox,
    },
    bg = {
      type = "linear",
      from = { 0, 0 },
      to = { 250, 0 },
      stops = { { 0, beautiful.bg .. "66" }, { 1, beautiful.bg .. 'dd' } }
    },
    shape = helpers.rrect(12),
    widget = wibox.container.background,
  },
  {
    {
      {
        {
          {
            id            = "icon",
            image         = gears.filesystem.get_configuration_dir() .. "theme/assets/weather/icons/weather-fog.svg",
            opacity       = 0.9,
            clip_shape    = helpers.rrect(4),
            forced_height = 80,
            forced_width  = 80,
            valign        = "center",
            widget        = wibox.widget.imagebox
          },
          {
            id = "desc",
            font = beautiful.sans .. " 12",
            markup = "Scattered Clouds",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          spacing = 10,
          layout = wibox.layout.fixed.vertical,
        },
        nil,
        {
          {
            id = "temp",
            font = beautiful.sans .. " 32",
            markup = "31 C",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          {
            id = "fl",
            font = beautiful.sans .. " 12",
            markup = "Feels Like 30 C",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          {
            id = "humid",
            font = beautiful.sans .. " 12",
            markup = "Humidity: 30%",
            valign = "center",
            widget = wibox.widget.textbox,
          },
          spacing = 10,
          layout = wibox.layout.fixed.vertical,
        },
        layout = wibox.layout.align.horizontal,
      },
      nil,
      {
        {
          day1,
          day2,
          day3,
          day4,
          day5,
          day6,
          spacing = 25,
          layout = require("mods.overflow").horizontal,
          scrollbar_width = 0,
        },
        widget = wibox.container.margin,
        top = 15,
      },
      layout = wibox.layout.align.vertical,
    },
    widget = wibox.container.margin,
    margins = {
      left = 30,
      right = 30,
      top = 20,
      bottom = 20,
    },
  },
  layout = wibox.layout.stack,
}

awesome.connect_signal("signal::weather", function(out)
  helpers.gc(widget, "image").image = helpers.cropSurface(1.53, gears.surface.load_uncached(out.thumb))
  helpers.gc(widget, "icon").image = out.image
  helpers.gc(widget, "temp").markup = out.temp .. "°C"
  helpers.gc(widget, "desc").markup = out.desc
  helpers.gc(widget, "humid").markup = "Humidity: " .. out.humidity .. "%"
  helpers.gc(widget, "fl").markup = "Feels Like " .. out.temp .. "°C"
  for i, j in ipairs(daylist) do
    j.update(out, i)
  end
end)

return widget
