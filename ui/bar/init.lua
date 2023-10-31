local awful     = require("awful")
local wibox     = require("wibox")
local beautiful = require("beautiful")
local dpi       = require("beautiful").xresources.apply_dpi
local helpers   = require('helpers')

local profile   = require("ui.bar.mods.profile")
local tags      = require("ui.bar.mods.tags")
local task      = require("ui.bar.mods.task")
local battery   = require("ui.bar.mods.battery")

local function init(s)
  local wibar = awful.wibar {
    position = "bottom",
    height = 60,
    ontop = false,
    width = 1920,
    bg = beautiful.bg,
    fg = beautiful.fg1,
    screen = s,
    widget = {

      {
        {
          {
            profile,
            {
              {
                tags(s),
                widget = wibox.container.margin,
                left = 15,
                right = 15,
              },
              shape = helpers.rrect(5),
              widget = wibox.container.background,
              bg = beautiful.mbg,
            },
            spacing = 15,
            layout = wibox.layout.fixed.horizontal
          },
          widget = wibox.container.place,
          valign = "center"
        },
        widget = wibox.container.margin,
        left = 15,
      },
      {
        {
          {
            task.widget,
            widget = wibox.container.margin,
          },
          widget = wibox.container.place,
          valign = "center",
          halign = "left",
        },
        widget = wibox.container.margin,
        left = 10,
      },
      {
        {
          {
            {
              {
                battery,
                spacing = 15,
                layout = wibox.layout.fixed.horizontal
              },
              widget = wibox.container.margin,
              top = 10,
              bottom = 10,
              left = 10,
              right = 10
            },
            widget = wibox.container.background,
            shape = helpers.rrect(5),
            bg = beautiful.mbg
          },
          widget = wibox.container.place,
          valign = "center",
        },
        widget = wibox.container.margin,
        right = 10,
      },
      layout = wibox.layout.align.horizontal,
    }
  }
  return wibar
end

screen.connect_signal('request::desktop_decoration', function(s)
  s.wibox = init(s)
end)
