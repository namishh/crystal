local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local json = require("mods.json")
local beautiful = require("beautiful")

local themes = { "biscuit", "cat", "decay", "everblush", "forest", "fullerene", "kizu", "monokai", "oxo", "solarized",
  "stardewnight",
  "sweetpastel", "verdant", "vixima" }

local index = helpers.indexOf(themes, beautiful.scheme)

local M = {
  current = beautiful.scheme,
  colors = {
    red = beautiful.red,
    green = beautiful.green,
    yellow = beautiful.yellow,
    blue = beautiful.blue,
    magenta = beautiful.magenta,
    bg = beautiful.bg,
    fg = beautiful.fg
  }
}

function M:previous()
  index = index - 1
  if index < 1 then
    index = #themes
  end
  M:getColors(themes[index])
  M:setColors()
end

function M:next()
  index = index + 1
  if index > #themes then
    index = 1
  end
  M:getColors(themes[index])
  M:setColors()
end

function M:getColors(scheme)
  scheme       = scheme or self.current
  local colors = require("theme.colors." .. scheme)
  self.colors  = colors
  self.current = scheme
end

function M:setColors()
  helpers.gc(self.widget, "red").bg = self.colors.err
  helpers.gc(self.widget, "blue").bg = self.colors.pri
  helpers.gc(self.widget, "green").bg = self.colors.ok
  helpers.gc(self.widget, "yellow").bg = self.colors.warn
  helpers.gc(self.widget, "magenta").bg = self.colors.dis
  helpers.gc(self.widget, "fg").bg = self.colors.fg
  helpers.gc(self.widget, "bg").bg = self.colors.mbg
  helpers.gc(self.widget, "name").markup = self.current:gsub("^%l", string.upper)
end

M.widget = wibox.widget {
  {
    {
      {
        {
          id     = "name",
          markup = M.current,
          font   = beautiful.sans .. " 14",
          widget = wibox.widget.textbox
        },
        nil,
        {
          {
            markup  = "󰅁",
            font    = beautiful.icon .. " 18",
            widget  = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                M:previous()
              end)
            },
          },
          {
            markup  = "󰅂",
            font    = beautiful.icon .. " 18",
            widget  = wibox.widget.textbox,
            buttons = {
              awful.button({}, 1, function()
                M:next()
              end)
            },
          },
          layout = wibox.layout.fixed.horizontal
        },
        layout = wibox.layout.align.horizontal
      },
      {
        {
          {
            id = "red",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.red
          },
          {
            id = "green",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.green
          },
          {
            id = "yellow",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.yellow
          },
          {
            id = "blue",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.blue
          },
          {
            id = "magenta",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.magenta
          },
          {
            id = "fg",
            widget = wibox.container.background,
            forced_height = 60,
            forced_width = 60,
            bg = M.colors.fg
          },
          spacing = 20,
          layout = wibox.layout.fixed.horizontal,
        },
        valign = "center",
        halign = "center",
        widget = wibox.container.place,
      },
      nil,
      layout = wibox.layout.align.vertical,
    },
    widget = wibox.container.margin,
    margins = 12
  },
  id = "bg",
  forced_height = 200,
  shape = helpers.rrect(10),
  widget = wibox.container.background,
  bg = M.colors.bg
}

M:getColors(beautiful.scheme)
M:setColors()

return M
