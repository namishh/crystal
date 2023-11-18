local awful = require("awful")
local helpers = require("helpers")
local wibox = require("wibox")
local gears = require("gears")
local json = require("mods.json")
local beautiful = require("beautiful")

local O = function(label, var)
  local M = { label = label, value = var, def = var }

  M.textbox = wibox.widget {
    font = beautiful.sans .. " 12",
    markup = helpers.colorizeText(M.value, beautiful.fg),
    widget = wibox.widget.textbox,
    valign = "center",
    align = "start",
    forced_width = 75,
  }

  function M:getInput()
    awful.prompt.run({
      textbox      = M.textbox,
      text         = M.value,
      bg_cursor    = beautiful.fg .. '22',
      exe_callback = function(input)
        -- If no input is present, display old contents.
        if not input or #input == 0 then
          M.textbox.markup = helpers.colorizeText(M.def, beautiful.fg)
          return
        end
        -- else update textbox and variable.
        if string.match(input, "[^%d%.]") ~= nil then
          M.textbox.markup = helpers.colorizeText(M.def, beautiful.fg)
          M.value = M.def
        else
          M.value = input
          M.textbox.markup = helpers.colorizeText(input, beautiful.fg)
        end
      end
    })
  end

  M.widget = wibox.widget {
    {
      {
        M.textbox,
        widget = wibox.container.margin,
        top = 10,
        bottom = 10,
        left = 10,
        right = 10,
      },
      shape = helpers.rrect(10),
      widget = wibox.container.background,
      bg = beautiful.mbg,
      buttons = {
        awful.button(nil, 1, function()
          M:getInput()
        end)
      }
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
