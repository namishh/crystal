local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local json = require("mods.json")
local beautiful = require("beautiful")

local O = function(label, tv, fv, var)
  local M = { label = label, value = var, def = var }

  M.box = wibox.widget {
    bg = var == tv and beautiful.fg or beautiful.bg,

    shape = helpers.rrect(100),
    widget = wibox.container.background,
    forced_height = 12,
    forced_width = 12,
  }

  function M:refresh()
    self.box.bg = self.value == tv and beautiful.fg or beautiful.bg
  end

  function M:toggle()
    if M.value == tv then
      M.value = fv
    else
      M.value = tv
    end
    self:refresh()
  end

  M.widget = wibox.widget {
    {
      {
        {
          {
            bg = beautiful.bg,
            shape = helpers.rrect(100),
            shape_border_width = 2,
            shape_border_color = beautiful.fg,
            widget = wibox.container.background,
            forced_height = 24,
            forced_width = 24,
          },
          widget = wibox.container.place,
          valign = "center"
        },
        {
          M.box,
          widget = wibox.container.place,
          valign = "center"
        },
        buttons = {
          awful.button(nil, 1, function()
            M:toggle()
          end)
        },
        widget = wibox.layout.stack
      },
      widget = wibox.container.place,
      valign = "center"
    },
    {
      font = beautiful.sans .. " Light 11",
      markup = helpers.colorizeText(M.label, beautiful.fg),
      widget = wibox.widget.textbox,
      valign = "start",
      align = "start"
    },
    spacing = 12,
    layout = wibox.layout.fixed.horizontal
  }

  return M
end

return O
