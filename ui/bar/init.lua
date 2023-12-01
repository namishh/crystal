local awful       = require("awful")
local wibox       = require("wibox")
local beautiful   = require("beautiful")
local dpi         = require("beautiful").xresources.apply_dpi
local helpers     = require('helpers')

local profile     = require("ui.bar.mods.profile")
local tags        = require("ui.bar.mods.tags")
local task        = require("ui.bar.mods.task")
local battery     = require("ui.bar.mods.battery")
local wifi        = require("ui.bar.mods.wifi")
local bluetooth   = require("ui.bar.mods.bluetooth")
local music       = require("ui.bar.mods.music")
local hourminutes = require("ui.bar.mods.time")
local layout      = require("ui.bar.mods.layout")
local systray     = require("ui.bar.mods.systray")

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
            layout,
            {
              {
                {
                  align = 'center',
                  font = beautiful.icon .. " 16",
                  markup = helpers.colorizeText('󱓟', beautiful.fg),
                  widget = wibox.widget.textbox,
                },
                widget = wibox.container.margin,
                top = 10,
                bottom = 10,
                left = 10,
                right = 10
              },
              widget = wibox.container.background,
              shape = helpers.rrect(5),
              bg = beautiful.mbg,
              buttons = {
                awful.button({}, 1, function()
                  awesome.emit_signal('toggle::dash')
                end)
              },
            },
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
      },
      {
        {
          {
            systray,
            music,
            {
              {
                {
                  battery,
                  wifi,
                  bluetooth,
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
              bg = beautiful.mbg,
              buttons = {
                awful.button({}, 1, function()
                  awesome.emit_signal('toggle::control')
                end)
              },
            },
            hourminutes,
            {
              {
                {
                  {
                    align = 'center',
                    font = beautiful.icon .. " 16",
                    markup = helpers.colorizeText('󰂜', beautiful.fg),
                    widget = wibox.widget.textbox,
                    buttons = {
                      awful.button({}, 1, function()
                        awesome.emit_signal('toggle::notify')
                      end)
                    },
                  },
                  {
                    align = 'center',
                    font = beautiful.icon .. " 16",
                    markup = helpers.colorizeText('󰐥', beautiful.red),
                    widget = wibox.widget.textbox,
                    buttons = {
                      awful.button({}, 1, function()
                        awesome.emit_signal('toggle::exit')
                      end)
                    },
                  },
                  spacing = 20,
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
              bg = beautiful.mbg,
            },
            layout = wibox.layout.fixed.horizontal,
            spacing = 10,
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
