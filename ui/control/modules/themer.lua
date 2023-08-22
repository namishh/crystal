local wibox       = require("wibox")
local awful       = require("awful")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require("helpers")
local gears       = require("gears")

local setTheme    = function(name)
  awful.spawn.with_shell('notify-send "Changing theme to ' .. name .. '" "This might take some time!"')
  awful.spawn.with_shell('setTheme ' .. string.lower(name))
end

local currTheme   = beautiful.name
local drawing     = wibox.widget {
  resize = true,
  forced_width = 480,
  forced_height = 250,
  shape = helpers.rrect(3),
  widget = wibox.widget.imagebox,
  horizontal_fit_policy = "fit",
  vertical_fit_policy = "fit",
  image = helpers.cropSurface(2,
    gears.surface.load_uncached("/home/namish/.config/awesome/theme/pics/tp/" ..
      string.lower(currTheme) .. ".png"))
}
local name        = wibox.widget {
  markup = currTheme,
  font   = beautiful.font .. " 12",
  widget = wibox.widget.textbox
}
local themes      = {
  'wave',
  'forest',
  'cat',
  'groove',
  'onedark',
  'verdant',
  'arctic'
}

local pos         = helpers.indexOf(themes, currTheme)

local finalwidget = wibox.widget {
  {
    {
      {
        drawing,
        {
          {
            widget = wibox.widget.textbox,
          },
          bg = {
            type = "linear",
            from = { 0, 0 },
            to = { 350, 0 },
            stops = { { 0, beautiful.bg .. "31" }, { 1, beautiful.bg .. 'f1' } }
          },
          widget = wibox.container.background,
        },
        {
          {
            {
              {
                {
                  markup = "󰅁",
                  font   = beautiful.icofont .. " 18",
                  widget = wibox.widget.textbox
                },
                widget = wibox.container.margin,
                buttons = awful.button({}, 1, function()
                  if pos >= 1 then
                    pos = pos - 1
                    currTheme = themes[pos]
                    drawing.image = helpers.cropSurface(2,
                      gears.surface.load_uncached("/home/namish/.config/awesome/theme/pics/tp/" ..
                        string.lower(currTheme) .. ".png"))
                    name.markup = currTheme
                  end
                end),
              },
              {
                {
                  markup = "󰅂",
                  font   = beautiful.icofont .. " 18",
                  widget = wibox.widget.textbox
                },
                widget = wibox.container.margin,
                buttons = awful.button({}, 1, function()
                  if pos <= #themes then
                    pos = pos + 1
                    currTheme = themes[pos]
                    drawing.image = helpers.cropSurface(2,
                      gears.surface.load_uncached("/home/namish/.config/awesome/theme/pics/tp/" ..
                        string.lower(currTheme) .. ".png"))
                    name.markup = currTheme
                  end
                end),
              },
              {
                {
                  markup = "Set Theme",
                  font   = beautiful.font .. " 12",
                  widget = wibox.widget.textbox
                },
                widget = wibox.container.margin,
                buttons = awful.button({}, 1, function()
                  setTheme(currTheme)
                end),
              },
              spacing = 10,
              layout = wibox.layout.fixed.horizontal
            },
            widget = wibox.container.place,
            halign = 'right',
            valign = 'bottom',
          },
          widget = wibox.container.margin,
          bottom = 10,
          right = 10,
        },
        {
          {
            name,
            widget = wibox.container.place,
            halign = 'right',
            valign = 'top',
          },
          widget = wibox.container.margin,
          top = 10,
          right = 10,
        },
        widget = wibox.layout.stack
      },
      spacing = 15,
      layout = wibox.layout.fixed.vertical
    },
    widget = wibox.container.margin,
  },
  widget = wibox.container.background,
  bg = beautiful.bg2 .. 'cc',
}

awesome.connect_signal("update::control", function()
  drawing.image = helpers.cropSurface(2,
    gears.surface.load_uncached("/home/namish/.config/awesome/theme/pics/tp/" ..
      string.lower(currTheme) .. ".png"))
end)
return finalwidget
